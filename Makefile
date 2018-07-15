# Root of the container, everything referenced from this.
#
export OS_UBOOT_CONTAINER_ROOT := $(shell pwd)
include ${OS_UBOOT_CONTAINER_ROOT}/config/machine.mk
export OS_UBOOT_ROOT := ${OS_UBOOT_CONTAINER_ROOT}/u-boot
export OS_UBOOT_DEPLOY_ROOT := ${OS_UBOOT_CONTAINER_ROOT}/deploy
export OS_UBOOT_TOOLS_ROOT := ${OS_UBOOT_ROOT}/tools
export OS_UBOOT_CONFIG_ROOT := ${OS_UBOOT_CONTAINER_ROOT}/config
export OS_UBOOT_SCRIPTS_ROOT := ${OS_UBOOT_CONTAINER_ROOT}/bin

.PHONY: all
all: container_submodule_init uboot_standard uboot_standard_tools

.PHONY: uboot_standard
uboot_standard: uboot_standard_defconfig
	make -C ${OS_UBOOT_ROOT} 
	cp -p ${OS_UBOOT_ROOT}/u-boot.img ${OS_UBOOT_DEPLOY_ROOT}/u-boot.bin
	cp -p ${OS_UBOOT_ROOT}/spl/boot.bin ${OS_UBOOT_DEPLOY_ROOT}/boot.bin

.PHONY: uboot_standard_tools
uboot_standard_tools:
	make -C ${OS_UBOOT_ROOT} tools
	cp -p ${OS_UBOOT_TOOLS_ROOT}/mkenvimage ${OS_UBOOT_DEPLOY_ROOT}

.PHONY: uboot_standard_defconfig
uboot_standard_defconfig: check_env
	@ if [ -f ${OS_UBOOT_ROOT}/.config ]; \
          then \
            echo "U-Boot Contains <.config> file, not overwriting";\
          else\
            make -C ${OS_UBOOT_ROOT} zynq_sapucb_defconfig; \
          fi;

.PHONY: uboot_standard_xconfig
uboot_standard_xconfig: check_env
	make -C ${OS_UBOOT_ROOT} xconfig

.PHONY: uboot_standard_clean
uboot_standard_clean:
	make -C ${OS_UBOOT_ROOT} distclean

.PHONY: uboot_deploy_clean
uboot_deploy_clean:
	rm -rf ${OS_UBOOT_DEPLOY_ROOT}/*

.PHONY: uboot_clean
uboot_clean: uboot_deploy_clean uboot_standard_clean

.PHONY: container_submodule_init
container_submodule_init:
	@ git submodule update --init

.PHONY: check_env
check_env:
	@ ${OS_UBOOT_SCRIPTS_ROOT}/do_chk_env.sh set

