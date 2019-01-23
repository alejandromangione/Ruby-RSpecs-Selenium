require_relative  "readConf"
require "json"
require "selenium-webdriver"
require "rspec"

describe "Add Product and checkout" do
	  
  before(:each) do		
	config = ReadConfig.new()	
	lt_user = ENV['LT_USERNAME']
	lt_appkey = ENV['LT_APPKEY']
	lt_os = ENV['LT_OPERATING_SYSTEM']
	lt_browser = ENV['LT_BROWSER']
	lt_browser_version = ENV['LT_BROWSER_VERSION']
	if(lt_user == "" || lt_user == nil)
		lt_user = config.getDetails('LT_USERNAME')
	end
	if(lt_appkey == "" || lt_appkey == nil)
		lt_appkey = config.getDetails('LT_APPKEY')
	end
	if(lt_browser == "" || lt_browser == nil)
		lt_browser = config.getDetails('LT_BROWSER')
	end
	if(lt_os == "" || lt_os ==nil)
		lt_os = config.getDetails('LT_OPERATING_SYSTEM')
	end
	if(lt_browser_version == "" || lt_browser_version == nil)
		lt_browser_version = config.getDetails('LT_BROWSER_VERSION')
	end	
	caps = {						
		:browserName => lt_browser,			
		:version => lt_browser_version,			
		:platform =>  lt_os,
		:name =>  "RSpec Sample Test",
        :build =>  "RSpec Selenium Sample",       
        :network =>  true,
        :visual =>  true,
        :video =>  true,
        :console =>  true
	} 	
	puts (caps)
	@driver = Selenium::WebDriver.for(:remote,
		:url => "https://"+lt_user+":"+lt_appkey+"@hub.lambdatest.com/wd/hub",
		:desired_capabilities => caps)
	
	@driver.manage.window.maximize
	
	@driver.get("https://lambdatest.github.io/sample-todo-app/" )
	sleep(3)		
  end
  
  after(:each) do   
    @driver.quit	
  end
  
  it "Select a product and add into cart, Checkout" do  
	itemName = 'Yey, Lets add it to list'  
	#Click on First Checkbox 
    @driver.find_element(:name, 'li1').click
   
    #Click on Second Checkbox 
    @driver.find_element(:name, 'li2').displayed?
   
    #Enter item name    
    @driver.find_element(:id, 'sampletodotext').send_keys itemName
        

    @driver.find_element(:id, 'addbutton').displayed?
    @driver.find_element(:id, 'addbutton').click     
   
    # Verify Item added successfully
    textAddedItem = @driver.find_element(:css, "[class='list-unstyled'] li:nth-child(6) span").text
    expect(textAddedItem).to eq(itemName)
  end    
  
end
