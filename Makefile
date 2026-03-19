SHELL=/bin/bash

.PHONY: ci clean local remote

local: index.src.html
	bikeshed --die-on=warning spec index.src.html index.html

remote: index.html

ci: index.src.html index.html
	mkdir -p out
	cp index.html out/

clean:
	rm index.html

index.html: index.src.html
	@ (HTTP_STATUS=$$(curl https://www.w3.org/publications/spec-generator/ \
	                       --output index.html \
	                       --write-out "%{http_code}" \
	                       --header "Accept: text/plain, text/html" \
	                       -F type=bikeshed-spec \
	                       -F die-on=warning \
	                       -F file=@index.src.html) && \
	[[ "$$HTTP_STATUS" -eq "200" ]]) || ( \
		echo ""; cat index.html; echo ""; \
		rm -f index.html; \
		exit 22 \
	);
