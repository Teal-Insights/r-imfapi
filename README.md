# Teal Insights R Package Template

This repository is a template repository for creating a Teal Insights R package. It includes testthat for tests and pkgdown for documentation.

Clone this repository with `git clone https://github.com/Teal-Insights/RpackageTemplate.git newpackagename`. Navigate into the project folder and disconnect your cloned repository from the template repository:

```bash
cd newpackagename
git remote remove origin
```

Find and replace all placeholders 'packagename', 'packagetitle', 'packagedescription', and 'packagelicense' with the appropriate values for your package.

Commit changes and publish to a new repository:

```bash
git add .
git commit -m "Initial commit"
gh repo create Teal-Insights/newpackagename --private --source=. --push
```

Members of the Teal Insights organization can use the command-line tool [RpackageCreator](https://github.com/Teal-Insights/RpackageCreator) to automate this workflow.