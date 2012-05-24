motion-rubygems adds (primitive and broken) support for (one or two) Rubygems to RubyMotion 

Installation
------------

WARNING: By typing `--pre` you admit that *everything is broken*. Please don't even try using this if you want anything to work at all.

```
$ gem install motion-rubygems --pre
```

Usage
-----

To use motion-rubygems, first add `require 'motion-rubygems'` to the top of your Rakefile:

```ruby
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'motion-rubygems'
```

And then add gems to your app in the setup block:

```ruby

Motion::Project::App.setup do |app|
  # ...
  app.gems = %w(andand)
end
```

Making gems motion-rubygems compatible
--------------------------------------

This is quite hard at the moment (see under "How does this even work?!!" for details).

Essentially your gem will be required with the constant `RUBYMOTION_VERSION="1.6"` or similar.

At compile time, you should `require` all the files that you need (note that at runtime, `require`s will be deferred to the end of the current file; so don't do anything that needs the result of the require later on in the current file). The `requires` are fully evaluated, so if you require a file from inside another file, that's fine.

At runtime you should then run RubyMotion compatible ruby. There are a few restrictions (like, no `eval`, or `define_method`), and a few random strange quirks of the runtime. Good luck!

(There's no way to tell the difference between compile time and run time yet, it's coming...)

Snake Oil Warning
-----------------

Warning, most gems *do not work* with motion-rubygems. This is for a few reasons:

1. The gem uses features of ruby that RubyMotion doesn't yet support (eval, define_method, autoload, etc.)
2. The gem uses a C extension.
3. The gem is highly load-order dependent.
4. It just randomly segfaults and I don't know why.

Success cases
-------------

Gems I've tested and seem to at least compile include:

* andand, custom_boolean

Uh, yeah, that's it. Sorry folks :(.

How does this even work!?
-------------------------

As you'll know, RubyMotion doesn't support `require`, but Rubygems require it.

To get round this we (at compile time) load the gem and write down all the files it requires. We then add all of these files to the app; and make RubyMotion compile them.

At *runtime*, we temporarily override require to do nothing, hope that none of the bad things listed above happen, and then let RubyMotion load all the files in order.

TODO
----

* Come up with conventions for writing RubyMotion gems so that they look like normal RubyGems. (not actually technically hard, but requires some people-skills!)

* Work out how to include shared libraries. (In theory this is doable, but I need to talk to someone from the RubyMotion team about how to actually do it; I guess the main hard bit is supporting the ruby C API?).

* Find common problems that stop lots of rubygems from working on RubyMotion, and work out sweeping solutions. (yeah, *dream on*)

If everything doesn't work, Why did you do this?
------------------------------------------------

At the moment you can't use rubygems with RubyMotion at all, and that makes me really sad.

The ideas being thrown around about packaging ruby motion gems make them totally incompatible with other ruby platforms, and that makes me quite sad too.

Obviously there are going to be RubyMotion specific gems, and gems that RubyMotion doesn't support; however I assert that gems which work everywhere are *the most important*.

It's incredibly awesome to be able to run the same code on the JVM and on an iPhone, and even (with mruby) on your dishwasher.

Meta-fu
-------

This is released under the MIT license, pull-requests are very very welcome!



