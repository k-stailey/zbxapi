#License:: GPL 2.0  http://www.gnu.org/licenses/gpl-2.0.html
#Copyright:: Copyright (C) 2009,2010 Andrew Nelson nelsonab(at)red-tux(dot)net
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

##########################################
# Subversion information
# $Id$
# $Revision$
##########################################

require 'rubygems'
require 'rake/gempackagetask'

$version = "0.1"
$rev = %x[svn -R info * 2>&1 | grep Revis | cut -f2 -d" "|sort -ur|head -1].chop.to_i


spec = Gem::Specification.new do |s|
  s.name = %q{zbxapi}
  s.rubyforge_project = "zbxapi"
  s.version = "#{$version}.#{$rev}"
  s.authors = ["A. Nelson"]
  s.email = %q{nelsonab@red-tux.net}
  s.summary = %q{Ruby wrapper to the Zabbix API}
  s.homepage = %q{http://trac.red-tux.net/}
  s.description = %q{Provides a straight forward interface to manipulate Zabbix servers using the Zabbix API.}
  s.licenses = "LGPL 2.1"
  s.requirements = "Requires json"
  s.add_dependency('json')
  s.require_paths =["."]
  s.files =
    ["zbxapi.rb", "zbxapi/zdebug.rb", "zbxapi/api_exceptions.rb",
     "zbxapi/exceptions.rb", "zbxapi/revision.rb",
     "zbxapi/utils.rb",
     "api_classes/application.rb",
     "api_classes/history.rb", "api_classes/host.rb",
     "api_classes/host_group.rb","api_classes/item.rb",
     "api_classes/proxy.rb", "api_classes/graph.rb",
     "api_classes/sysmap.rb", "api_classes/trigger.rb",
     "api_classes/user.rb", "api_classes/user_group.rb",
     "api_classes/subclass_base.rb"]
end


#task :get_revision do
#  $rev = %x[svn -R info * 2>&1 | grep Revis | cut -f2 -d" "|sort -ur|head -1].chop.to_i
#end

desc "Update the revision to the lastest svn number"
task :update_revision do

  open("zbxapi/revision.rb", "w") do |o|
    o.puts "#CHANGES TO THIS FILE WILL AUTOMATICALLY BE OVERWRITTEN"
    o.puts "#This file is autogenerated by the zbxapi rakefile."
    o.puts "#This file contains the latest SVN revision number at the time"
    o.puts "#the rakefile was run"
    o.puts
    o.puts "ZBXAPI_VERSION=\"#{$version}\""
    o.puts "ZBXAPI_REVISION=\"#{$rev}\""
  end
end

task :checkout_zbxapi do
  %x[svn co http://svn.red-tux.net/trunk/ruby/api zbxapi_tmp] unless ENV["SKIP_CHECKOUT"]
end

desc "Cleanup"
task :cleanup do
  %x[rm -rf zbxapi_tmp]
end

desc "Build dependencies to test Zabcon"
task :test => [:update_revision, :checkout_zbxapi]


task :default => [:update_revision, :package]

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.package_dir = "gems"
#  pkg.version = "0.1.#{$rev}"
end
