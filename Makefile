URL_ACG = "https://docs.google.com/spreadsheets/d/1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs/export?format=tsv&id=1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs&gid=445984614"

TARGETS = ACG.kbl
TSV_FILES = ACG.tsv

SCRIPTS_SRC = $(wildcard *.applescript)
SCRIPTS_BIN = $(SCRIPTS_SRC:.applescript=.scpt)

all:	$(TARGETS) $(SCRIPTS_BIN)

clean:
	rm $(TARGETS) $(TSV_FILES) $(SCRIPTS_BIN)

download: $(TSV_FILES)

%.kbl: %.tsv
	ruby genkbl.rb < $*.tsv > $*.kbl

%.tsv:
	curl -o $@ $(URL_$*)

%.scpt: %.applescript
	osacompile -o $@ $<
