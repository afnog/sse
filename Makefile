DEFAULT_TARGETS = presos_odp presos_pdf docs_pdf guides_pdf
all: $(DEFAULT_TARGETS)
clean:
	rm -rf $(DST_DIR)

help:
	@echo "Usage: make [V=1] <target>..."
	@echo 
	@echo "Targets:"
	@echo "  all:        Build the usual suspects [$(DEFAULT_TARGETS)]"
	@echo "  clean:      Delete the output directory [output] and all contents"
	@echo "  presos_odp: Make .odp files for presentations"
	@echo "  presos_odp_clean:"
	@echo "              Delete .odp files for presentations"
	@echo "  presos_odp_force:"
	@echo "              Delete and rebuild all .odp files for presentations"
	@echo "  presos_pdf, presos_pdf_clean, presos_pdf_force:"
	@echo "              Similarly for .pdf files for presentations"
	@echo "  docs_pdf, docs_pdf_clean, docs_pdf_force:"
	@echo "              Similarly for .pdf files for documents (exercises and manuals)"
	@echo "  guides_pdf, guides_pdf_clean, guides_pdf_force:"
	@echo "              Similarly for .pdf files for guide/study documents"

# Directories where various files should be found or written to:
SRC_DIR = src
DST_DIR = output
TEMPLATES_DIR = templates
PROJECT_DIR_ABS = $(shell pwd)
STATIC_DIR_ABS  = $(PROJECT_DIR_ABS)/static

# Macros to manipulate relative paths, for use in URLs:
REMOVE_TRAILING_SLASH = $(patsubst %/,%,$(1))
INVERT_PATH = $(shell echo $(call REMOVE_TRAILING_SLASH,$(1)) | sed -e 's|[^/]*|..|g')
# $(RELATIVE_URL_TO_ROOT) inverts whatever target (output file)
# we are producing at the moment, which we get from the $@ variable:
RELATIVE_URL_TARGET_TO_ROOT = $(call INVERT_PATH,$(dir $@))

# Automatically find all the presentation and guide input files.
PRESOS = $(wildcard $(SRC_DIR)/*/Unit_*/Unit_*_Presentation*.rst)
GUIDES = $(wildcard $(SRC_DIR)/*/*.rst) \
         $(wildcard $(SRC_DIR)/Network_Management/One_Week_Training_Course/*.rst)
EXERS = $(wildcard $(SRC_DIR)/*/Unit_*/Unit_*_Exercises.rst)
MANUALS = $(wildcard $(SRC_DIR)/*/Unit_*/Unit_*_Manual.rst)
SOURCE_DIRS = $(wildcard $(SRC_DIR)/*/Unit_*)

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

# Document processing commands for each output format.
PANDOC_COMMON = $(PANDOC_BIN) --data-dir=. --smart \
	--variable static-url=$(RELATIVE_URL_TARGET_TO_ROOT)/static \
	--variable static-dir=$(STATIC_DIR_ABS)
PANDOC_PDF_BEAMER = $(PANDOC_COMMON) -t beamer --latex-engine=xelatex \
	--toc --toc-depth=4 \
	--template=$(TEMPLATES_DIR)/beamer.tex --variable handout=1
# ".. include::" doesn't work, so work around it with the -B option:
# https://groups.google.com/forum/?fromgroups=#!topic/pandoc-discuss/75zqDF9ZMkg
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

PRESO_ODP_FILES = $(call FILES_PATTERN,.odp,$(PRESOS))
presos_odp: $(PRESO_ODP_FILES)
# $(PRESO_ODP_FILES): $(call MAKE_PATTERN,.odp)
$(PRESO_ODP_FILES): $(DST_DIR)/%.odp: $(SRC_DIR)/% $(TEMPLATES_DIR)/presentation.odp
	$(CREATE_DESTDIR)
	$(LINK_IMAGES)
	$(RST2ODP_V) $< $@
	$(UNLINK_IMAGES)
presos_odp_clean:
	$(RM_V) $(PRESO_ODP_FILES)

NOTES_FILE = Facilitators_Notes.pdf
NOTES_INTERMED = $(NOTES_FILE).src.rst
PRESO_PDF_FILES = $(call FILES_PATTERN,/$(NOTES_FILE),$(SOURCE_DIRS))

presos_pdf: $(PRESO_PDF_FILES)
$(PRESO_PDF_FILES): %/$(NOTES_FILE): %/$(NOTES_INTERMED)
	$(CREATE_DESTDIR)
	$(RST2PDF_V) -o $@ $^

# rst2pdf only supports one input file, so we must combine them first
PRESO_PDF_INTERMEDS = $(call FILES_PATTERN,/$(NOTES_INTERMED),$(SOURCE_DIRS))
# can't tell if a file has been deleted, so always rebuild the pdfs

.PHONY: $(PRESO_PDF_INTERMEDS)
$(PRESO_PDF_INTERMEDS): $(DST_DIR)/%/$(NOTES_INTERMED):
# Create the intermediate files, output/Network_Management/Unit_XX/pdf.src.rst
# by catting the source files together; and also symlinks to the includes and
# images directory, so that rst2pdf can find images and files referenced by the
# input files, although it's working in a different directory.
	$(CREATE_DESTDIR)
	$(SILENT) cat $(SRC_DIR_FOR_CURRENT_TARGET)/Unit_*_Presentation*.rst > $@
# replace PNGs with SVGs for high-res graphics in PDFs
# $(SILENT) for png in `grep 'images/.*png' $@ | sed -e 's/.*:: //' | sort | uniq`; do svg=`echo $$png | sed -e 's/\.png$$/.svg/'`; if test -r $(@D)/$$svg; then sed -i -e "s|$$png|$$svg|" $@; fi; done
# create symlinks for images and includes directories in output dirs
	$(RM_V)   $(DST_DIR_FOR_CURRENT_TARGET)/images
	$(SILENT) ln -sf $(PROJECT_DIR_ABS)/$(SRC_DIR_FOR_CURRENT_TARGET)/images $(DST_DIR_FOR_CURRENT_TARGET)/images
	$(RM_V)   $(DST_DIR)/Network_Management/includes
	$(SILENT) ln -sf $(PROJECT_DIR_ABS)/$(SRC_DIR)/Network_Management/includes 	$(DST_DIR)/Network_Management/includes

presos_pdf_clean:
	$(RM_V) $(PRESO_PDF_FILES) $(PRESO_PDF_INTERMEDS)

EXER_PDF_FILES = $(call FILES_PATTERN,.pdf,$(EXERS))
MANUAL_PDF_FILES = $(call FILES_PATTERN,.pdf,$(MANUALS))
DOC_PDF_FILES = $(EXER_PDF_FILES) $(MANUAL_PDF_FILES)
docs_pdf: $(DOC_PDF_FILES)
$(DOC_PDF_FILES): $(call MAKE_PATTERN,.pdf)
	$(CREATE_DESTDIR)
	$(LINK_IMAGES)
	$(RST2PDF_V) $^ -o $@
	$(UNLINK_IMAGES)
docs_pdf_clean:
	$(RM_V) $(DOC_PDF_FILES)


GUIDE_PDF_FILES = $(call FILES_PATTERN,.pdf,$(GUIDES))
guides_pdf: $(GUIDE_PDF_FILES)
$(GUIDE_PDF_FILES): $(call MAKE_PATTERN,.pdf)
	$(CREATE_DESTDIR)
	$(LINK_IMAGES)
	$(RST2PDF_V) $^ -o $@
	$(UNLINK_IMAGES)
guides_pdf_clean:
	$(RM_V) $(GUIDE_PDF_FILES)

