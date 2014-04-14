URL_ACG = "https://docs.google.com/spreadsheets/d/1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs/export?format=tsv&id=1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs&gid=445984614"

TARGETS = ACG.kbl
TSV_FILES = ACG.tsv

all:	$(TARGETS)

clean:
	rm $(TARGETS) $(TSV_FILES)

download: $(TSV_FILES)

%.kbl: %.tsv
	ruby genkbl.rb < $*.tsv > $*.kbl

%.tsv:
	curl -o $@ $(URL_$*)

