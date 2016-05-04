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
      out.print("clidriver installation is going on \n ")
      cmd = "touch ~/.bashrc; rm -rf  #{app_dir}/clidriver; rm -rf odbc_cli_v10.5fp6_linuxx64.tar.gz "
     # cmd = 'echo $HOME; touch ~/.bashrc; pwd ; '
      @shell.exec(cmd, out)
      out.print("remove old clidriver folder \n ")
      cmd = "rm -rf  #{app_dir}/clidriver"
       @shell.exec(cmd, out)
      
      
       #out.print("present working directory display")
       cmd = " rm -rf odbc_cli_v10.5fp6_linuxx64.tar.gz; rm -rf #{app_dir}/odbc_cli; "
       
       @shell.exec(cmd, out)
      cmd =  "curl -X GET -H \"Authorization: Basic b25lY29ubmVjdDpibHVlY29ubmVjdA==\" -o odbc_cli_v10.5fp6_linuxx64.tar.gz \"http://oneconnect.mybluemix.net/ds/drivers/download/odbccli64/linuxamd64/v10.5fp6?Accept-License=yes\" "
     #cmd = " curl -X GET -H \"Authorization: Basic b25lY29ubmVjdDpibHVlY29ubmVjdA==\" -o odbc_cli_v10.5fp6_linuxx64.tar.gz \"http://oneconnect.mybluemix.net/ds/drivers/download/odbccli64/linuxamd64/v10.5fp6?Accept-License=yes\" ; tar zxvf #{app_dir}/odbc_cli_v10.5fp6_linuxx64.tar.gz -C #{app_dir}/clidriver &> /dev/null "
     @shell.exec(cmd, out)
     
     cmd = " tar zxvf #{app_dir}/../odbc_cli_v10.5fp6_linuxx64.tar.gz -C #{app_dir}/ "
     @shell.exec(cmd, out)
     #cmd = "rm -rf #{app_dir}/clidriver; "
     cmd = "ls #{app_dir}" 
     @shell.exec(cmd, out)
      
      #cmd = "mkdir -p #{app_dir}/clidriver; chmod 777 #{app_dir}/clidriver; tar xvf #{app_dir}/v10.5fp6_linuxx64_odbc_cli.tar -C #{app_dir}/clidriver  "
      #@shell.exec(cmd, out)	  
     
      cmd = "cp -Rvf #{app_dir}/libdb2.so.1 #{app_dir}/odbc_cli/clidriver/lib/libdb2.so.1"
      @shell.exec(cmd, out)
	  
      @shell.env['LD_LIBRARY_PATH'] = "$LD_LIBRARY_PATH:#{app_dir}/odbc_cli/clidriver/lib"
      @shell.env['PATH'] = "$PATH:#{app_dir}/odbc_cli/clidriver/bin"
	  
      #cmd = 'echo $LD_LIBRARY_PATH; echo $PATH; bash -c  db2cli validate -dsn alias1 -connect'
      cmd = 'echo $LD_LIBRARY_PATH; echo $PATH;  '
      @shell.exec(cmd, out)
      
      cmd = "/bin/cp -Rvf #{app_dir}/db2dsdriver.cfg #{app_dir}/odbc_cli/clidriver/cfg "
      @shell.exec(cmd, out)
      #cmd = echo 
      #; db2cli validate -dsn alias1 -connect '
      cmd = "db2cli validate -dsn alias1 -connect"
      @shell.exec(cmd, out)      
    end	
  end
end
