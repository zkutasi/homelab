# Budgeting

When it comes to money, finances, or investments, there are a few apps to help out to keep a budget, make it painfully visible and help keep track of things.

## Requirements

- Free and Open source, preferably 0$ cost
- Ability to show a flow-graph: Where the money goes visually
- Some form of ability to import spendings from my Bank account or statement PDFs/Exports. I can export in CSV, XLS and JSON from my Bank.
  - For automatic imports
    - [GoCardless](https://gocardless.com/)
    - [SimpleFIN](https://www.simplefin.org/)
    - [LunchFlow](https://www.lunchflow.app/)
  - For manual imports
    - Handle re-importing (for example every X days I export the yearly statement) and omit the already imported transactions (for example using a transactionID or date+amount)
    - Handle flexibly the CSV format: encoding, delimiter, headers, date formats, and signed amounts, or evenweird stuff (like NBSP separator in the amount)

## Contenders

- [Firefly III](https://firefly-iii.org/) - Extremely complex app, but has the most features, also [third party tooling](https://docs.firefly-iii.org/references/firefly-iii/third-parties/apps/) is available like Phone apps, importers and more.
- [Actual Budget](https://actualbudget.org/) - Very popular app as it is much simpler than Firefly III. Handles all kinds of imports, and based on the envelope budgeting principle.
- [What you Get is What You Have (WYGIWYH)](https://github.com/eitchtee/WYGIWYH) - A no-budget approach. Supports schema-based CSV imports (very flexible, duplication-resistant so it supports periodic re-importing), multi-currency, multi-account support.
- [EZBookkeeping](https://ezbookkeeping.mayswind.net/) - Supports multiple import formats, multi currency and language support, AI ops for receipt recognition and MCP Server too. Every transaction must be tagged as either income or expense... it is not deducted by the sign of the numbers, nothing is automatic here. But one could add also a script (JS) to import, so there is even more flexibility to solve everything. The creator explains in github issues that the import is not meant to be used in a periodic fashion and the App is meant to be filled manually as one goes.
- [Ocular](https://simonwep.github.io/ocular/) - One needs to type the numbers manually as import only supports Google Sheets's Annual Planner. Separate money flow into income and expenses and create groups, where one need to manually sum those groups per month (it seems), like Groceries. Very simple, not really easy to automate.
- [OpenBudgeteer](https://github.com/TheAxelander/OpenBudgeteer) - Based on the Bucket Budgeting principle. Simply it has 4 bucket tipes, supports CSV imports from bank documents (format is a question). Euro only?
- [BudgetBoard](https://budgetboard.net/) - Supports SimpleFIN or CSV import, deducted by the sign of the amount. Only graphs trends, no flow graph or pie chart available. Transaction have to be still categorized, but can be done by rules as well, even after the import. Able to do more, like Assets, Budgets, Goals, but everything is manually entered.
- [ExpenseOwl](https://github.com/Tanq16/ExpenseOwl) - Very simple, expense tracker, not a budgeting app. Only graphs monthly expenses by category in a pie chart. Can import from CSV but only its own format. Contains only limited currencies.
- [Sure](https://github.com/we-promise/sure) - A Fork of the discontinued [Maybe](https://github.com/maybe-finance/maybe) app
- [Wally](https://github.com/polius/Wally) - Based on ExpenseOwl, a very small fork

### Portfolio trackers

- [Ghostfolio](https://ghostfol.io/)
- [Rotki](https://github.com/rotki/rotki)
- [Wealthfolio](https://github.com/afadil/wealthfolio)
- [Investbrain](https://github.com/investbrainapp/investbrain)
- [Portfolio Performance](https://www.portfolio-performance.info/en/)

### Recurring subscription tracking

- [Wallos](https://github.com/ellite/Wallos)
- [MonetR](https://monetr.app/)
- [Subtrackr](https://github.com/bscott/subtrackr)
