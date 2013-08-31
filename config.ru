run lambda { |env| [200, { 'Content-Type'=>'text/plain'}, StringIO.new("Test config.ru\n")] }
