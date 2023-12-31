# Documentation
Here below documentation provided for accomplished task for the Thrive Challenge.

## Author:
```
Oleg Saltykov 

oleg.saltykov@gmail.com
```

## Build instruction:

This application built using using pure Ruby 3.1.2 (no db all in memory) with several 
application dependencies listed at the [Gemfile](Gemfile)

For starting given rails application locally it is required to run next console commands:

```console
bundle install      # install all Ruby gems
```
As intended for running console application need to trigger [challenge.rb](challenge.rb) over the console

```console
ruby challenge.rb
```
Follow simple Q&A prompts suggested in the app for outputing result to target txt file.

Run basic unit test for Reports::Company::Txt service, which is basically assemble context for writing for each company 

```console
rspec text_spec.rb  # run basic unit test
```

## Flow examples
![flow_exmaple.png](flow_exmaple.png)

## Error Handling
- If an error occurs during the fetching data, you will get error message displayed over the console
![error_handling_example.png](error_handling_example.png)

## Notes
- Unit tests and manual testing is available. So that can prove correctness in some fashion.
- Code might be not the cleanest and test coverage only covered base one record assembling case. But I hope it brings some main idea.

## THANK YOU!
![](https://media.giphy.com/media/JabEe2N1Eoln076wiC/giphy.gif)
