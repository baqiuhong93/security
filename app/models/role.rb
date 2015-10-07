# encoding: utf-8

class Role < ActiveRecord::Base

  attr_accessible :action_name, :controller_name, :description, :http_method, :name, :query_string
  has_and_belongs_to_many :permissions
  
  has_many :user_roles
  has_many :users, :through => :user_roles
  
  APPS_MENUS = {1 => [{'id' => 10001, 'name' => '产品管理'}, {'id' => 10002, 'name' => '产品树管理'}, {'id' => 10003, 'name' => '知识点树管理'}, {'id' => 10004, 'name' => '课程包管理'}, {'id' => 10005, 'name' => '老师管理'}, {'id' => 10006, 'name' => '订单管理'}, {'id' => 10007, 'name' => '听课账号管理'}, {'id' => 10008, 'name' => '卡管理'}, {'id' => 10009, 'name' => '账户记录管理'}, {'id' => 10010, 'name' => '笔记管理'}, {'id' => 10011, 'name' => '作业项目管理'}, {'id' => 10012, 'name' => '作业批改管理'}, {'id' => 10013, 'name' => '用户管理'}, {'id' => 10014, 'name' => '附件管理'}, {'id' => 10015, 'name' => '系统消息管理'}], 2 => [{'id' => 20001, 'name' => '权限管理'}, {'id' => 20002, 'name' => '用户管理'}], 3 => [{'id' => 30001, 'name' => '资讯管理'}, {'id' => 30002, 'name' => '文章管理'}, {'id' => 30003, 'name' => '域名管理'}, {'id' => 30004, 'name' => '片段管理'}, {'id' => 30005, 'name' => '模板管理'}, {'id' => 30006, 'name' => '关键词管理'}, {'id' => 30007, 'name' => '来源管理'}, {'id' => 30008, 'name' => 'TAG管理'}, {'id' => 30009, 'name' => '信息管理'}]}
  
  def self.get_menus(app_id)
    return APPS_MENUS[app_id]
  end
end
