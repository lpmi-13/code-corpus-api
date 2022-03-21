# Code Corpus API

This will be an API publicly available to grab selections from corpora of four different languages:

- Javascript
- Typescript
- Python
- Golang

Initially, it will only return functions, since that's the first thing I'm creating a corpus of. I'm expecting later to be able to provide various other things like control flow examples, variable declarations, and other interesting things.

## System Architecture

![Initial system design](./system_design.svg)

## Things the API will return

> (this will eventually be a swagger spec or something, but for now just writing down thoughts)

- one random function for a particular language
- N random functions for a particular language (probably cap at 10 or something)
- list of repos for a given language (paginate this)
- one random function for a particular repo

Considerations for different "filters" on the query:

- filter functions by "difficulty" (we'll probably have to just use number of lines here, though an eventual analysis of the actual corpus could help us figure out a better metric)
- filter functions by "internal criteria", for example whether the function contains a particular control flow like `if` blocks, or whether it has a return value or not. This is aspirational for the time being, since the currently data collection method doesn't annotate functions with any of this information.

Metadata that we might want to have available for API results:

- owner/repository
- full URL to the original file (we might be interested in actual line numbers for the function definition, but we need a strategy to keep the data fresh if we go this route...we could _maybe_ get around this if we also grabbed that actual commit SHA, which presumably could always get us to the original function, even if later commits change what's in the HEAD of the file)
- date retrieved
- language of the function

Open questions:

- Do we actually want to return data structures like what's currently used for the parsons problems web app? ie, with code as an array of objects of the form `[{"line_number":3, line_content: "    return computedValue"}...]`? It could be that allowing clients to do that parsing if they want to is cleaner and couples the data less to a particular expected usage (like parsons problems). The biggest problem is I have absolutely no idea how people would want to actually use this, so I might as well just return a very general data structure and then iterate based on actual feedback, if there is any.
