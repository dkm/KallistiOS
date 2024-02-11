# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#
disable_libada=""

ifneq (,$(findstring ada,$(pass2_languages)))
	disable_libada=--disable-libada
endif

$(build_gcc_pass2): build = build-gcc-$(target)-$(gcc_ver)-pass2
$(build_gcc_pass2): logdir
	@echo "+++ Building $(src_dir) to $(build) (pass 2)..."
	-mkdir -p $(build)
	> $(log)
	cd $(build); \
        ../$(src_dir)/configure \
          --target=$(target) \
          --prefix=$(prefix) \
	        $(disable_libada) \
          --with-newlib \
          --disable-libssp \
          --enable-threads=$(thread_model) \
          --enable-languages=$(pass2_languages) \
          --enable-checking=release \
          $(extra_configure_args) \
          $(macos_gcc_configure_args) \
          CC="$(CC)" \
          CXX="$(CXX)" \
          $(static_flag) \
          $(to_log)
	$(MAKE) $(makejobs) -C $(build) DESTDIR=$(DESTDIR) $(to_log)
ifneq (,$(findstring ada,$(pass2_languages)))
	  $(MAKE) $(makejobs) -C $(build)/gcc cross-gnattools DESTDIR=$(DESTDIR) $(to_log)
endif
	$(MAKE) -C $(build) $(install_mode) DESTDIR=$(DESTDIR) $(to_log)
	$(clean_up)
