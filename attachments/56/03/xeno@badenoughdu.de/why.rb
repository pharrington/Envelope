require 'rbconfig'
bui = /^bui(.{2})$/
$stdout << "#{{}.class}"[0,1] <<
 ("#{{}.methods}"[/c(\w{4})c/] && $1.reverse) <<
 (([0]*2).inspect[2,2]) <<
 Config::CONFIG.keys.grep(bui).first.gsub(bui,
   "#{Kernel.methods.grep(/^th/)[0][2,3].reverse}\\1") <<
 ObjectSpace._id2ref(338)
