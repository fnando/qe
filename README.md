# Qe

A simple interface over several background job libraries like Resque, Sidekiq and DelayedJob.

## Usage

In this wild world where a new asynchronous job processing
library is released every once in a while, Qe tries to keep a unified
interface that works with the most famous libraries:

* [Sidekiq](http://mperham.github.com/sidekiq/)
* [Resque](https://github.com/defunkt/resque/)
* [DelayedJob](https://github.com/collectiveidea/delayed_job)
* [Qu](https://github.com/bkeepers/qu)
* [Beanstalk](https://github.com/kr/beanstalkd)/[Backburner](http://nesquena.github.com/backburner/)

To set the adapter, just load the file according to your adapter:

``` ruby
require "qe/resque"
require "qe/qu"
require "qe/delayed_job"
require "qe/beanstalk"
```

If you're using Rails with Bundler, you can simple require the correct file.

``` ruby
source :rubygems
gem "rails", "3.2.8"
gem "qe", :require => "qe/sidekiq"
```

Create a worker that will send e-mails through `ActionMailer`.

``` ruby
class MailerWorker
  include Qe::Worker

  def perform
    Mailer.public_send(options[:mail], options).deliver
  end
end
```

Define our `Mailer` class.

``` ruby
class Mailer < ActionMailer::Base
  def welcome(options)
    @options = options
    mail :to => options[:email]
  end
end
```

Enqueue a job to be processed asynchronously.

``` ruby
MailerWorker.enqueue({
  :mail => :welcome,
  :email => "john@example.org",
  :name => "John Doe"
})
```

## Development support

Qe comes with development support. Instead of starting up workers on development environment, you can use the `Qe::Immediate` adapter, which executes your worker right away!

``` ruby
Qe.adapter = Qe::Immediate
```

If you're using Rails, you can add the line above to your `config/environments/development.rb` file.

## Testing support

Qe also comes with testing support. Just require the `qe/testing.rb` file
and a fake queuing adapter will be used. All enqueued jobs will be stored
at `Qe.jobs`. Note that this method is only available on testing mode.

``` ruby
require "qe/testing"
Qe.adapter = Qe::Testing
```

If you"re using RSpec, you can require the `qe/testing/rspec.rb` file
instead. This will reset `Qe.jobs` before every spec and will add a
`enqueue` matcher.

``` ruby
# Add the following like to your spec_helper.rb file
require "qe/testing/rspec"

describe "Enqueuing a job" do
  it "enqueues job" do
    expect {
      # do something
    }.to enqueue(MailerWorker).with(:email => "john@example.org")
  end
end
```


Maintainer
----------

* Nando Vieira (<http://nandovieira.com.br>)

License:
--------

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
