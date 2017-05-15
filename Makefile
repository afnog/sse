DEFAULT_TARGETS = output
all: $(DEFAULT_TARGETS)
clean:
	rm -rf $(DST_DIR)

help:
	@echo "Usage: make [V=1] <target>..."
	@echo 
	@echo "Targets:"
	@echo "  all:        Build the usual suspects [$(DEFAULT_TARGETS)]"
	@echo "  clean:      Delete the output directory [$(DST_DIR)] and all contents"
	@echo "  output:     Build the output directory [$(DST_DIR)] using Jekyll"
	@echo "  watch:      Watch for source changes and rebuild outputs in $(DST_DIR)"
	@echo "  serve:      Run built-in HTTP server"
	@echo "  sync:       Watch for file changes in $(DST_DIR) and sync to $(SYNC_HOST):$(SYNC_DIR)"
	@echo "  autocommit: Build, autocommit and push the output directory"

# Directories where various files should be found or written to:
SRC_DIR = .
DST_DIR = ../afnog.github.io/sse
REPO_DIR = ../afnog.github.io
TEMPLATES_DIR = templates
PROJECT_DIR_ABS = $(shell pwd)
STATIC_DIR_ABS  = $(PROJECT_DIR_ABS)/static
# Host and directory to be overwritten by "make sync"
# These must now be edited in $(LSYNCD_CONF) instead:
# SYNC_HOST = 196.200.223.173
# SYNC_DIR  = /u/vol/www/afnog2014/sse
LSYNCD_CONF := lsyncd.conf

# Macros to manipulate relative paths, for use in URLs:
REMOVE_TRAILING_SLASH = $(patsubst %/,%,$(1))
INVERT_PATH = $(shell echo $(call REMOVE_TRAILING_SLASH,$(1)) | sed -e 's|[^/]*|..|g')
# $(RELATIVE_URL_TO_ROOT) inverts whatever target (output file)
# we are producing at the moment, which we get from the $@ variable:
RELATIVE_URL_TARGET_TO_ROOT = $(call INVERT_PATH,$(dir $@))

# Automatically find all the presentation and guide input files.
PRESO_SOURCES = $(shell find $(SRC_DIR) -name presentation.md)

# Ways of hiding commands. Show the full command when you run "make V=1",
# otherwise just the name of the command and the output file.
#
# You can use $(SILENT) to hide a command completely:
SILENT = $(if $(V),,@)
#
# Or $(call QUIET,foo,$@,foo -k bar $@) to show only a command name "foo" and
# the output file $@, and run "foo -k bar $@" behind the scenes:
QUIET = $(if $(V), $3, @ printf "  [%.8s] $2\n" $1 && $3)

# Document processing executables, specified here so that you can
# override the executable (to run a different version, e.g. a local
# installed copy) separately from changing the command-line args passed
# to it, below.
PANDOC_BIN  = pandoc
RST2PDF_BIN = PYTHONPATH=tools/rst2pdf-0.93 python tools/rst2pdf-0.93/rst2pdf/createpdf.py
RST2ODP_BIN = PYTHONPATH=tools/rst2odp      python tools/rst2odp/bin/rst2odp
JEKYLL_BIN  = jekyll
LSYNC_BIN   = lsyncd

# Document processing commands for each output format.
PANDOC_COMMON = $(PANDOC_BIN) --data-dir=. --smart \
	--variable static-url=$(RELATIVE_URL_TARGET_TO_ROOT)/static \
	--variable static-dir=$(STATIC_DIR_ABS)
PANDOC_PDF_BEAMER = $(PANDOC_COMMON) -t beamer --latex-engine=xelatex \
	--toc --toc-depth=4 \
	--template=$(TEMPLATES_DIR)/beamer.tex --variable handout=1
PANDOC_PDF_READABLE = $(PANDOC_COMMON) -t latex --latex-engine=xelatex \
	--toc --toc-depth=4 \
	--template=$(TEMPLATES_DIR)/readable.tex --variable handout=1 \
	-B src/includes/Series.rst \
	-B src/includes/Authors.rst
RST2PDF = $(RST2PDF_BIN) \
	--stylesheets=$(TEMPLATES_DIR)/rst2pdf.styles.txt \
	--font-path=static/CharisSIL-4.112-web \
	--smart-quotes=1
RST2ODP = $(RST2ODP_BIN) --traceback \
	--template-file=$(TEMPLATES_DIR)/presentation.odp
JEKYLL_OPTS = --source $(PROJECT_DIR_ABS)/$(SRC_DIR) \
	--destination $(PROJECT_DIR_ABS)/$(DST_DIR)

# LSYNC_OPTS = -nodaemon -log Exec -rsyncssh ../afnog.github.io/sse/ noc.mtg.afnog.org /tmp/sse/
# LSYNC   = $(LSYNC_BIN) $(LSYNC_OPTS) -rsyncssh $(DST_DIR) $(SYNC_HOST) $(SYNC_DIR)
LSYNC   = $(LSYNC_BIN) $(LSYNCD_CONF)

# Quiet aliases for common shell commands, for output readability
RST2ODP_V = $(call QUIET, rst2odp, $@, $(RST2ODP))
RST2PDF_V = $(call QUIET, rst2pdf, $@, $(RST2PDF))
RM_V      = $(SILENT) rm    -f $1
MKDIR_V   = $(SILENT) mkdir -p $1

# Commands that are used in multiple rules
CREATE_DESTDIR = $(call MKDIR_V, $(dir $@))
LINK_IMAGES    = $(SILENT) # ln -sf $((dir $^):$(DST_DIR)=$(PROJECT_DIR_ABS)/$(SRC_DIR)) $(dir $^)/images 
UNLINK_IMAGES  = $(SILENT) # rm $(dir $^)/images

# Make is target-driven, so we need to provide target filenames and
# rules to generate each target filename from a source filename (we
# use pattern rules where possible to do that).
# 
# ONE_TARGET_FILE_PER_SOURCE_FILE creates target filenames from source
# filenames, by transforming all the items in the supplied list,
# removing some prefixes and suffixes, and adding others instead. So
# for example you can transform:
#   src/Network_Management/Unit_1/Unit_1_Presentation.rst
# into:
#   output/Network_Management/Unit_1/Unit_1_Presentation.pdf
# with this command:
#   $(call ONE_TARGET_FILE_PER_SOURCE_FILE,src/Network_Management/Unit_1/Unit_1_Presentation.rst,src,.rst,output,.pdf)
#
# The function parameters are:
#   $1: the list of sources, for example $(PRESOS) and/or $(GUIDES)
#   $2: the source base directory, often $(SRC_DIR), which is
#     removed from each source filename by pattern matching
#   $3: the suffix to remove from each source filename by pattern
#     matching, for example .rst
#   $4: the output directory, often $(DST_DIR), which is added to the
#     source filename to create the target filename
#   $5: the extension to be added to the target filename, for
#     example .html.

ONE_TARGET_FILE_PER_SOURCE_FILE = $(1:$2/%$3=$4/%$5)

# FILES_PATTERN calls ONE_TARGET_FILE_PER_SOURCE_FILE with these parameters:
#   $1: the extension to be added to the target filename
#   $2: the list of sources, for example $(PRESOS)
FILES_PATTERN = $(call ONE_TARGET_FILE_PER_SOURCE_FILE,$2,$(SRC_DIR),,$(DST_DIR),$1)

# MAKE_PATTERN creates a Make rule for building files in the destination dir
# from files with the same name in the source dir, by adding a suffix, which
# is the first argument. The second, optional argument is the suffix to be
# added to the source files or directories.
MAKE_PATTERN = $(DST_DIR)/%$1: $(SRC_DIR)/%$2

SRC_DIR_FOR_CURRENT_TARGET = $(@D:$(DST_DIR)/%=$(SRC_DIR)/%)
DST_DIR_FOR_CURRENT_TARGET = $(@D)

debug:
	@echo PRESO_ODP_FILES = $(PRESO_ODP_FILES)
	@echo PRESOS = $(PRESOS)
	@echo PRESOS make rules = $(call MAKE_PATTERN,.odp)

output: run_jekyll_first

run_jekyll_first:
	$(JEKYLL_BIN) build $(JEKYLL_OPTS)

PRESOS_HTML_OUTPUTS = $(call FILES_PATTERN,.html,$(PRESO_SOURCES))
$(PRESOS_HTML_OUTPUTS): $(DST_DIR)/%.html: $(SRC_DIR)/%
	cat $(TEMPLATES_DIR)/remark/header.html $^ $(TEMPLATES_DIR)/remark/footer.html \
		> $@

presos_clean:
	rm -f $(PRESOS_HTML_OUTPUTS)

watch:
	$(JEKYLL_BIN) build $(JEKYLL_OPTS) --watch

serve:
	$(JEKYLL_BIN) serve $(JEKYLL_OPTS) --watch

sync:
	$(LSYNC)

autocommit:
	@ $(JEKYLL_BIN) build $(JEKYLL_OPTS) >/dev/null
	@ cd $(DST_DIR); if ! git diff -s --exit-code .; then git add -A .; git commit -q -m "autocommit by Makefile"; git push -q; fi

