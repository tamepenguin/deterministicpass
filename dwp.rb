#!/usr/bin/env ruby
require 'digest'




class DeterministicPassword
  @valid_characters  = "01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"     
  @base_secret       = "TGIF" 
  @complexity_regexp = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/ 
  class << self; attr_accessor :valid_characters, :base_secret, :complexity_regexp, :password_length end
    
  
     
  
  def self.determininstic_pass (kw=0)
    wlanpass = ""
    loop = 0
     
    while ! self.complex?( wlanpass)
  
      pwseed = "%s %i %i loop %i" % [@base_secret, kw,2016, loop]
        
      wlanpass = ""
      Digest::SHA256.digest( pwseed ).each_byte do |byte|
        index = ( byte.to_f / 255 * (@valid_characters.length - 1) ).round
        wlanpass += @valid_characters[ index ]
      end
      wlanpass = wlanpass.slice!(0,@password_length)
      
      loop += 1
      if loop > 100
        raise StandardError, "Could not find a complex enough password for 100 tries - please lower your standards or modifiy the allowed characters %i." % loop
      end
        
    end
    
    return wlanpass  
  end
  
  
  def self.complex? (password)
    password =~ @complexity_regexp ? true: false 
  end
end




a =  DeterministicPassword


a.base_secret = "NecNeNec"

  0.upto(2) do |kw|
      pass = a.determininstic_pass kw
      if a.complex? pass
        p " %i %s: %s" % [kw,a.complex?(pass), pass]
      else
        print "%i %s FAAAAAAAAAAAAAAAAAAAIL" % [kw, pass]
      end
    end
