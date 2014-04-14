ACG_TSV = "https://docs.google.com/spreadsheets/d/1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs/export?format=tsv&id=1h_x3L9_LTKC2GCYo_nkjZvLlzpsWwMSzKjZqzCRsHWs&gid=445984614"

TARGETS = ACG.kbl
TSV_FILES = ACG.tsv

all:	$(TARGETS)

clean:
	rm $(TARGETS) $(TSV_FILES)

download: $(TSV_FILES)

ACG.kbl: ACG.tsv
	ruby genkbl.rb < ACG.tsv > ACG.kbl

ACG.tsv:
	curl -o ACG.tsv $(ACG_TSV)

