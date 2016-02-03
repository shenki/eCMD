# Makefile for the ecmd Extensions

# *****************************************************************************
# Define base info and include any global variables
# *****************************************************************************
SUBDIR     := ext/${EXTENSION_NAME}/cmd/
include ../../../../makefile.vars

EXTENSION_NAME_u := $(shell echo ${EXTENSION_NAME} | tr 'a-z' 'A-Z')
EXTENSION_NAME_u1 := $(shell perl -e 'printf(ucfirst(${EXTENSION_NAME}))')

INCLUDES     := ${INCLUDES} ${EXTENSION_NAME}Interpreter.H 
CAPI_INCLUDES := ${CAPI_INCLUDES} ${EXTENSION_NAME}Structs.H ${EXTENSION_NAME}ClientCapi.H
INT_INCLUDES := ecmdClientCapi.H  ecmdDataBufferBase.H  ecmdDataBuffer.H ecmdReturnCodes.H ecmdStructs.H ecmdUtils.H ecmdClientEnums.H ${CAPI_INCLUDES}

CFLAGS       := ${CFLAGS} -I../../../capi -I../capi -I../../../cmd/ -I../../../dll -I${SRCPATH}

SOURCE       := ${SOURCE} ${EXTENSION_NAME}Interpreter.C

# *****************************************************************************
# The Common Setup stuff
# *****************************************************************************
TARGET = ${EXTENSION_NAME}CmdInterpreter.a

VPATH := ${VPATH}:${OBJPATH}:../../../capi:../../template/capi:../capi:${SRCPATH}


# *****************************************************************************
# The Main Targets
# *****************************************************************************
# The all rule variables are defined in makefile.vars
all:
	@${CMD_DIR_MSG}
	@${CMD_DIR}
	@${CMD_GEN_MSG}
	@${CMD_GEN}
	@${CMD_BLD_MSG}
	@${CMD_BLD}

generate:
  # Do nothing

build: ${TARGET}

install:
	@echo "Installing ${EXTENSION_NAME_u} eCMD Extension Command Interpreter to ${INSTALL_PATH}/${TARGET_ARCH}/lib/ ..."
	@mkdir -p ${INSTALL_PATH}/ext/${EXTENSION_NAME}/cmd/
	cp ${OBJPATH}/${TARGET} ${INSTALL_PATH}/${TARGET_ARCH}/lib/.
	@echo "Installing ${EXTENSION_NAME_u} eCMD Extension Command Interpreter headers to ${INSTALL_PATH}/ext/${EXTENSION_NAME}/cmd/ ..."
	@cp ${EXTENSION_NAME}Interpreter.H ${INSTALL_PATH}/ext/${EXTENSION_NAME}/cmd/.
	@cp ../capi/${EXTENSION_NAME}Structs.H ${INSTALL_PATH}/ext/${EXTENSION_NAME}/cmd/.
	@cp ../capi/${EXTENSION_NAME}ClientCapi.H ${INSTALL_PATH}/ext/${EXTENSION_NAME}/cmd/.


# *****************************************************************************
# Object Build Targets
# *****************************************************************************
SOURCE_OBJS  = $(basename ${SOURCE})
SOURCE_OBJS := $(addprefix ${OBJPATH}, ${SOURCE_OBJS})
SOURCE_OBJS := $(addsuffix .o, ${SOURCE_OBJS})

# *****************************************************************************
# Compile code for the common C++ objects if their respective
# code has been changed.  Or, compile everything if a header
# file has changed.
# *****************************************************************************
${SOURCE_OBJS}: ${OBJPATH}%.o : %.C ${INCLUDES} ${INT_INCLUDES}
	@echo Compiling $<
	${VERBOSE}${CC} -c ${CFLAGS} $< -o $@ ${DEFINES}


# *****************************************************************************
# Create the Client Archive
# *****************************************************************************
${TARGET}: ${SOURCE_OBJS} ${LINK_OBJS}
	@echo Creating $@
	${VERBOSE}${AR} r ${OUTLIB}/${TARGET} $^

# *****************************************************************************
# Include any global default rules
# *****************************************************************************
include ${ECMD_ROOT}/makefile.rules