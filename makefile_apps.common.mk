#--------------------------------------------------------------------------;
# Description:
#
#---------------------------------------------------------------------------;

include $(INFRA_BUILD)/defs.mk
include $(INFRA_BUILD)/rules.mk

SOURCES += $(sources)
C_SOURCES := $(filter %.c,$(SOURCES))
CPP_SOURCES := $(filter %.cpp,$(SOURCES))
OBJECTS := $(C_SOURCES:.c=.o) $(CPP_SOURCES:.cpp=.o)

ifeq "$(BUILD_FOR_HOST)" "true"
CFLAGS += -fPIE -rdynamic -D__PROGNAME=\"$(PROG)\"
else
CFLAGS += -fPIE -rdynamic -mapcs -D__PROGNAME=\"$(PROG)\"
endif
INCLUDES += -I.

# when shared libraries are used, then use the target filesytem
#LIBRARIES += -L$(RT_TARGET_FS)/lib
#LIBRARIES += -L$(INFRA)/tools/v6_le_uclibc/target/usr/lib

ifeq "$(BCM_MEEGO_49)" "true"
LIBRARIES +=
else
LIBRARIES += -lpthread
endif
ifeq "$(BUILD_FOR_HOST)" "true"
else
LIBRARIES += -Wl,-rpath-link,$(INFRA)/lib
endif

ifeq "$(FEATURE_ASLR)" "1"
	LDFLAGS += -pie
endif

ifeq "$(SKIP_UNITTEST)" "TRUE"
ifdef EXTRAPROG
all: $(PROG) $(EXTRAPROG)
else
all: $(PROG)
endif
else # compiling & runing unittest by default
ifdef EXTRAPROG
all: $(UT_MAKETGT) $(PROG) $(EXTRAPROG)
else
all: $(UT_MAKETGT) $(PROG)
endif
endif

MatchPattern = "^[[:alnum:]]{8} <"
$(PROG): $(OBJECTS) $(extradepend)
	$(CXX) -rdynamic -mapcs $(STATIC) $(LDFLAGS) -o $(PROG) $(OBJECTS) $(LIBRARIES)
	$(OBJDUMP) -dthx $(PROG) | egrep $(MatchPattern) > $(PROG).map

include $(INFRA_BUILD)/apps.install.common.mk

symbols::
ifdef PROG
ifdef SYMBOL_LOCATION
	cp $(PROG) $(PROG).objdump $(SYMBOL_LOCATION)
endif
endif


ifeq "$(SKIP_UNITTEST)" "TRUE"
clean::
else
clean:: $(UT_CLEANTGT)
endif
ifdef PROG
	-$(RM) $(SRCDIR)/*.o 
	-$(RM) $(PROG)
	-$(RM) $(PROG).objdump
	-$(RM) $(PROG).map
	-$(RM) $(INFRA)/appmap/$(PROG).map
	@-$(RM) -f $(SRCDIR)/ses_static_analysis*  
	@-$(RM) -f $(SRCDIR)/kb.kb  
	@-$(RM) -f $(SRCDIR)/sestoolsin*  
	@-$(RM) -f $(SRCDIR)/*summary.log  
	@-$(RM) -f $(SRCDIR)/*details.log  
	@-$(RM) -rf $(SRCDIR)/ses_cstatic_*  
	@-$(RM) -f $(SRCDIR)/*ses_sa_*  
	@-$(RM) -f $(SRCDIR)/*.dg.*  
	@-$(RM) -f $(SRCDIR)/*.i  
	@-$(RM) -f $(SRCDIR)/*..preproc  
	@-$(RM) -f $(SRCDIR)/*.d
endif

include $(INFRA_BUILD)/rtsa.mk

nfs::
ifdef NFS
ifdef PROG
	-cp $(PROG) $(NFS)
endif
endif
