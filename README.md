# README
* Ruby version -> 2.5.3

* Configuration
    1. database
        - copy database.yml.example to database.yml  
            `cd config` from the project root directory  
            `cp database.yml.example database.yml`  
        - Edit the `host`, `username` and `password` under `default` block  
        - Edit the `database` under `development` block to your nlims database name  
    2. Install the dependencies
        - run the following command  
        `bundle install`
        - To install webpacker
         -- install yarn from [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/) then run the following command  
        `rails webpacker:install`

* Database migrations
    - Since the database is prexisting, no need for creation  
    - Run migration and seed   
        `rails db:migrate`  
        `rails db:seed`  
* Services (job queues)  
    - To track every day syncing of sites to nlims, add a cron job by running the following  
        `whenever --update-crontab --set environment='development'`  
* Run locally  
    `rails s`
