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
u.destroy
p 'name'
u.name = 'Joe'    
p 'created'                
u.created = DateTime.now   
p 'profile'       
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
                                  
                                  
p 'printing'                                  
u = User.new(:id => 1)  
p u.name.get                          
p u.created.get.strftime('%m/%d/%Y')  
p u.profile.get
p u.posts[0,20]                   
p u.posts[0]                      
p u.followers.has_key?(2)         
