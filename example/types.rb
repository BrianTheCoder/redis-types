require 'rubygems'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'redis/types'


class User
  include Redis::Types
  
  value :name,      String
  value :created,   DateTime
  value :profile,   Json
  
  list  :posts,     Json
  
  set   :followers, Integer
end



u = User.new(:id => 1)
# u.destroy
u.name = 'Joe'                    
u.created = DateTime.now          
u.profile = {                     
  :age => 23,                     
  :sex => 'M',                    
  :about => 'Lorem'               
}                                 
u.posts << {                      
    :title => "Hello world!",     
    :text  => "lorem"             
}                                 
u.followers << 2                  
                                  
                                  
                                  
u = User.new(:id => 1)  
p u.name                          
p u.created.strftime('%m/%d/%Y')  
p u.posts[0,20]                   
p u.posts[0]                      
p u.followers.has_key?(2)         
