HttpMachinegun
======================
It sends data (or get data) via http with The number-of-times thread.

install
------
`gem install http_machinegun`

usage
------
```ruby
http_machinegun fire -u #{url}
```
###example

```ruby
#simple get request by one times
http_machinegun fire -u localhost

#get request to 3000 port option by one times
http_machinegun fire -u localhost -p 3000

#post request with data by one times
http_machinegun fire -u localhost -d abc -m post
#or
http_machinegun fire -u localhost -d data.txt

#get request with data by ten times
http_machinegun fire -u localhost -t 10
```

###options
* -u, --url   
target url   

* -p, --port  
target port  
  
* -d, --data_or_file   
string or file path  

* -m, --method  
http method (get,post,put,delete )  
  
* -t, --thread_number  
request number of times you want    


