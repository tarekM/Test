require 'spec_helper'

describe UsersController do
    
    ########Test the add functions#######
    
    #ADD ONE USER
    describe "should let server add user with correct format" do
        it "should return SUCCESS" do
            post :add, :user => "user1", :password => "pw", :format => :json
            response.body.should == {:errCode => 1, :count => 1}.to_json
        end
    end
    
    #DUPLICATE USERNAME
    describe "duplicate usernames should not be allowed" do
        it "should return error -2" do
            new_User = User.new
            new_User.user = 'user1'
            new_User.save
            expect { post :add, :user => "user1", :password => "pass", :format => :json}.to change(User,:count).by(0)
            response.body.should == {:errCode => -2}.to_json
            end
        end
    
    #ADD TWO USERS
    describe "should let server add two users with correct format" do
        it "should return SUCCESS" do
            User.delete_all
            new_User = User.new
            new_User.user = 'user1'
            new_User.save
            post :add, :user => "user2", :password => "pw", :format => :json
            response.body.should == {:errCode => 1, :count => 1}.to_json
        end
    end
    
    #USERNAME IS BLANK
    describe "should not let user create username if blank" do
        it "should return error -3" do
            expect { post :add, :user => "", :password => "hello", :format => :json }.to change(User, :count).by(0)
            response.body.should == {:errCode => -3}.to_json
        end
    end

    #DUPLICATE PASSWORDS ALLOWED
    describe "should let duplicate passwords" do
        it "should return SUCCESS" do
            User.delete_all
            new_User = User.new
            new_User.user = 'user1'
            new_User.password="pw"
            new_User.save
            post :add, :user => "user2", :password => "pw", :format => :json
            response.body.should == {:errCode => 1, :count => 1}.to_json
        end
    end

    #TOO MANY CHARACTERS: USERNAME
    describe "more than 128 characters not allowed for username" do
        it "should return error -3" do
            expect { post :add, :user => "lfjaeljriaejrlkjeakljrlkaejslkrjaklsjrkleasjklrjasljrlkajslrkjaslrjklasaehrlashrkjhaklhrahreahjrlasjrlkasjlrkjlasjrasljrkelsajahjfkgdahfjadhfhdakjfhkahflahfjahfkhgasjfgkdaygfhjgasjgejagfjasgfaegsfgajkfgaehjfgeahjksgfjegahfjgajsegfjekasgfjgakjgfakjgfjkgaejgfhjkaegsr", :password => "hello", :format => :json }.to change(User, :count).by(0)
            response.body.should == {:errCode => -3}.to_json
        end
    end

    #TOO MANY CHARACTERS: PASSWORD
    describe "more than 128 characters not allowed for password" do
        it "should return error -4" do
            expect { post :add, :user => "user1", :password => "lfjaeljriaejrlkjeakljrlkaejslkrjaklsjrkleasjklrjasljrlkajslrkjaslrjklasaehrlashrkjhaklhrahreahjrlasjrlkasjlrkjlasjrasljrkelsajahjfkgdahfjadhfhdakjfhkahflahfjahfkhgasjfgkdaygfhjgasjgejagfjasgfaegsfgajkfgaehjfgeahjksgfjegahfjgajsegfjekasgfjgakjgfakjgfjkgaejgfhjkaegsr", :format => :json }.to change(User, :count).by(0)
            response.body.should == {:errCode => -4}.to_json
        end
    end

    ########Test the login functions########
    
    #CORRECT LOGIN
    describe "should login and increment count" do
        it "should return SUCCESS" do
            User.delete_all
            new_User = User.new
            new_User.user = 'user1'
            new_User.password='pw'
            new_User.count = 1
            new_User.save
            post :login, :user => "user1", :password => "pw", :format => :json
            response.body.should == {:errCode => 1, :count => 2}.to_json
        end
    end

    #NEW USER
    describe "should not be able to login" do
        it "should return error -1" do
            User.delete_all
            post :login, :user => "user1", :password => "pw", :format => :json
            response.body.should == {:errCode => -1}.to_json
        end
    end
    
    #WRONG PASSWORD
    describe "should login and increment count" do
        it "should return error -4" do
            User.delete_all
            new_User = User.new
            new_User.user = 'user1'
            new_User.password='pw'
            new_User.count = 1
            new_User.save
            post :login, :user => "user1", :password => "wrong", :format => :json
            response.body.should == {:errCode => -4}.to_json
        end
    end


end


