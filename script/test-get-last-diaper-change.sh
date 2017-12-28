#!/bin/bash
curl -XPOST -v -H "Accept: application/json" -H "Content-Type: application/json" -d @test/json/get_last_diaper_change.json http://localhost:4000/api/command
