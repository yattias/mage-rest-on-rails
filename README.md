# Magento REST API on Rails 4
A simple example of Magento's REST API on Rails 4 which also includes benchmarking + oauth annotations.

## Installation
- Clone this repo
- run ``bundle install``
- run ``rails server``

## Configuration
The only file you need to modify is ``settings/development.yml`` (follow the instructions in the file)

## Important routes
- ``/mage/make_rest_api_call`` # Will go through the oauth flow and make an API request once authorized
- ``/mage/benchmark`` # Benchmark's Magento's REST API

## Important files
All of the actions are annotated and defined in ``/controllers/mage_controller.rb``

