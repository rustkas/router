REBAR := ./rebar3
REBAR_URL := https://s3.amazonaws.com/rebar3/rebar3
ERL       ?= erl
DEPSOLVER_PLT=$(CURDIR)/.depsolver_plt

.PHONY: compile test shell dialyzer clean

all: compile

compile: $(REBAR)
	$(REBAR) compile

shell: $(REBAR)
	$(REBAR) shell

test: $(REBAR)
	$(REBAR) as test eunit -v

dialyzer: $(REBAR)
	$(REBAR) dialyzer

xref: $(REBAR)
	$(REBAR) as test xref

clean: $(REBAR) clean_doc
	$(REBAR) clean

clean_doc:
	@rm -f doc/*.html
	@rm -f doc/erlang.png
	@rm -f doc/edoc-info

doc: $(REBAR)
	$(REBAR) edoc

doc_private: $(REBAR)
	$(REBAR) as doc_private edoc

./rebar3:
	$(ERL) -noshell -s inets -s ssl \
	  -eval '{ok, saved_to_file} = httpc:request(get, {"$(REBAR_URL)", []}, [], [{stream, "./rebar3"}])' \
	  -s init stop
	chmod +x ./rebar3
