# Now that all the rubygems are loaded, re-instate the version of require that
# raises an exception to the user.
module Kernel
  alias require require_without_motion_rubygems
  undef require_without_motion_rubygems
end
