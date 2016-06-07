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

    def extract(app_dir, out)
      @shell.env['HOME'] = app_dir
      
      out.print("clidriver installation is going on \n ")
      cmd = "touch ~/.bashrc;"
      @shell.exec(cmd, out)
      
      out.print("remove old clidriver folder \n ")
      cmd = "rm -Rvf  #{app_dir}/clidriver; rm -Rvf #{app_dir}/odbc_cli;"
      @shell.exec(cmd, out)
    
      cmd =  "curl -X GET -H \"Authorization: Basic b25lY29ubmVjdDpibHVlY29ubmVjdA==\" -o odbc_cli_v10.5fp6_linuxx64.tar.gz \"http://oneconnect.mybluemix.net/ds/drivers/download/odbccli64/linuxamd64/v10.5fp6?Accept-License=yes\" "
      #cmd = " curl -X GET -H \"Authorization: Basic b25lY29ubmVjdDpibHVlY29ubmVjdA==\" -o odbc_cli_v10.5fp6_linuxx64.tar.gz \"http://oneconnect.mybluemix.net/ds/drivers/download/odbccli64/linuxamd64/v10.5fp6?Accept-License=yes\" ; tar zxvf #{app_dir}/odbc_cli_v10.5fp6_linuxx64.tar.gz -C #{app_dir}/clidriver &> /dev/null "
      @shell.exec(cmd, out)
     
      cmd = " tar zxvf #{app_dir}/../odbc_cli_v10.5fp6_linuxx64.tar.gz -C #{app_dir}/ "
      @shell.exec(cmd, out)
     
      cmd = "ls #{app_dir}; ls #{app_dir}/odbc_cli" 
      @shell.exec(cmd, out)
      
      cmd = "ls -lrt #{app_dir}/odbc_cli/clidriver/lib/"
      @shell.exec(cmd, out)
      
      #cmd = "cp -Rvf #{app_dir}/libdb2.so.1 #{app_dir}/odbc_cli/clidriver/lib/libdb2.so.1"
      #@shell.exec(cmd, out)
	  
      @shell.env['LD_LIBRARY_PATH'] = "$LD_LIBRARY_PATH:#{app_dir}/odbc_cli/clidriver/lib"
      @shell.env['PATH'] = "$PATH:#{app_dir}/odbc_cli/clidriver/bin"
      @shell.env['DB2NMPTRACE'] = 1
      @shell.env['DB2NMPCONSOLE'] = "#{app_dir}/db2log.txt" 
     
      cmd = "echo 'LD_LIBRARY_PATH' ;echo $LD_LIBRARY_PATH; echo $PATH; "
      @shell.exec(cmd, out)
      
      cmd = "ls -lrt #{app_dir}/odbc_cli/clidriver/lib" 
      @shell.exec(cmd, out)
      
      cmd = "/bin/cp -Rvf #{app_dir}/db2dsdriver.cfg #{app_dir}/odbc_cli/clidriver/cfg "
      @shell.exec(cmd, out)
      
       cmd = " rm -rf odbc_cli_v10.5fp6_linuxx64.tar.gz"
       @shell.exec(cmd, out)
     
      cmd = "db2cli validate -dsn alias1 -connect"
      @shell.exec(cmd, out)    
      
      out.print("copying ibm data core driver  \n ")
      cmd = "/bin/cp -Rvf #{app_dir}/IBM.Data.DB2.Core.dll #{app_dir}/.dnx/packages/IBM.Data.DB2.Core/10.5.5.100/lib/dnxcore50/IBM.Data.DB2.Core.dll"
      @shell.exec(cmd, out) 
      out.print("finished copying the driver \n ")
      
    end	
  end
end
