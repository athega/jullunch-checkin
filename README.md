jullunch-checkin
===============
A simple rubymotion app to handle the check in flow at the annual Athega christmas lunch.

Making it run
------------
* Clone and run [athega-jullunch](https://github.com/athega/athega-jullunchathega-jullunch) and [tomtelizer-server](https://github.com/athega/tomtelizer-server)
* Point `BASE_URL` in `http_client.rb` to `athega-jullunch`
* Point `UPLOAD_URL` in `http_client.rb` to `tomtelizer-server`

Todo
------
* Make it pretty
* Add tests
* The request fails when uploading images to the tomtelizer-server but the image along with the parameters are sent OK. `result.success? == false` on line 42 in `http_client.rb`


