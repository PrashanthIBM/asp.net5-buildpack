# Encoding: utf-8
# ASP.NET 5 Buildpack
# Copyright 2016 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module AspNet5Buildpack
  class ClidriverInstaller
    def initialize(app_dir, shell)
      @shell = shell
	  @app_dir = app_dir
    end

    def install(app_dir, out)
      @shell.env['HOME'] = app_dir
      #@dest_dir = app_dir/clidriver
	  
     # cmd = 'touch ~/.bashrc; curl -LO ftp://9.26.93.131/devinst/db2_v105fp6/linuxamd64/s150623/v10.5fp6_linuxx64_odbc_cli.tar.gz; rm -rf  #{app_dir}/odbc_cli; '
      cmd = 'echo $HOME; touch ~/.bashrc; pwd ; '
      @shell.exec(cmd, out)
	  
     cmd = "rm -rf #{app_dir}/clidriver; "
     #cmd = 'ls -lrt $HOME; which tar; tar zxv --help ; tar zxv $HOME/v10.5fp6_linuxx64_odbc_cli.tar.gz '
      @shell.exec(cmd, out)
      
      cmd = "mkdir -p #{app_dir}/clidriver; chmod 777 #{app_dir}/clidriver; tar xvf #{app_dir}/v10.5fp6_linuxx64_odbc_cli.tar -C #{app_dir}/clidriver  "
	  
      #cmd = 'cp -rf #{app_dir}/libdb2.so.1 #{app_dir}/odbc_cli/clidriver/lib/libdb2.so.1'
      # @shell.exec(cmd, out)
	  
      @shell.env['LD_LIBRARY_PATH'] = "$LD_LIBRARY_PATH:#{app_dir}/clidriver/odbc_cli/clidriver/lib"
      @shell.env['PATH'] = "$PATH:#{app_dir}/clidriver/odbc_cli/clidriver/bin"
	  
      #cmd = 'echo $LD_LIBRARY_PATH; echo $PATH; bash -c  db2cli validate -dsn alias1 -connect'
      cmd = 'echo $LD_LIBRARY_PATH; echo $PATH; ls -lRt #{app_dir}/clidriver/odbc_cli/clidriver/bin; '
      @shell.exec(cmd, out)
      
      #cmd = 'cp #{app_dir}/db2dsdriver.cfg #{app_dir}/clidriver/odbc_cli/clidriver/cfg/db2dsdriver.cfg ; db2cli validate'
      #cmd = 'db2cli validate'
      #@shell.exec(cmd, out)      
    end	
  end
end
