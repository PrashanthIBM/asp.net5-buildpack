# Encoding: utf-8
# ASP.NET 5 Buildpack
# Copyright 2014-2015 the original author or authors.
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

require 'rspec'
require_relative '../../../lib/buildpack.rb'

describe AspNet5Buildpack::CliDriverInstaller do
  let(:shell) { double(:shell, env: {}) }
  let(:out) { double(:out) }
  subject(:installer) { AspNet5Buildpack::CliDriverInstaller.new(shell) }

  describe '#install' do
  
    it 'creates .bashrc shell does not complain' do
      expect(shell).to receive(:exec).with(match('touch ~/.bashrc'), out)
      installer.install('passed-directory', out)
    end
    
    it 'downloads clidriver' do
      cmd = 'curl -LO ftp://db2ftp.torolab.ibm.com/devinst/db2_v105fp6/linuxamd64/s150623/v10.5fp6_linuxx64_odbc_cli.tar.gz'
      expect(shell).to receive(:exec).with(match(cmd), out)
      installer.install('passed-directory', out)
    end
    
    it 'remove existing clidriver location' do
      expect(shell).to receive(:exec).with(match('rm -rf  ~/odbc_cli'), out)
      installer.install('passed-directory', out)
    end
    
    it 'remove existing clidriver location' do
      expect(shell).to receive(:exec).with(match('tar -xvzf v10.5fp6_linuxx64_odbc_cli.tar.gz -C ~/'), out)
      installer.install('passed-directory', out)
    end
    
    it 'sets PATH env variable' do
      allow(shell).to receive(:exec)
      installer.install('~/odbc_cli/clidriver/bin/', out)
      expect(shell.env).to include('PATH' => '~/odbc_cli/clidriver/bin/')
    end
    
    it 'sets LD_LIBRARY_PATH env variable' do
      allow(shell).to receive(:exec)
      installer.install('~/odbc_cli/clidriver/lib/', out)
      expect(shell.env).to include('LD_LIBRARY_PATH' => '~/odbc_cli/clidriver/lib/')
    end
    
    it 'run db2cli validate' do
      expect(shell).to receive(:exec).with(match('db2cli validate'), out)
      installer.install('passed-directory', out)
    end
  end
end
