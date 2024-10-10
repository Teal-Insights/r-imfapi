# Teal Insights R Package Template

This repository is a template repository for creating an R package, following the Teal Insights style guide. It includes testthat for tests and pkgdown for documentation.

Clone this repository with `git clone https://github.com/Teal-Insights/RpackageTemplate.git newpackagename`. Navigate into the project folder, disconnect your cloned repository from the template repository, and publish to a new repository:

```bash
cd newpackagename
git remote remove origin
gh repo create Teal-Insights/newpackagename --private --source=. --remote=upstream
```

Find and replace all placeholders 'packagename', 'packagetitle', 'packagedescription', and 'packagelicense' with the appropriate values for your package.

Members of the Teal Insights organization can use the command-line tool [RpackageCreator](https://github.com/Teal-Insights/RpackageCreator) to automate this workflow.