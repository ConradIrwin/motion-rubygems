# We want require to be a no-op when running gem code as that is full of
# requires. Luckily RubyMotion will take care of requiring everything for us!
module Kernel
  alias require_without_motion_rubygems require
  def require(*); end
end
