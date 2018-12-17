library(stringr)
library(xml2)
library(rvest) #加载包
i<-1:30 #设定抓取页数
lagou_data<-data.frame()#创建数据框存储数据
#写个循环，对固定网页结构重复抓取
for (i in 1:30){
  web<-read_html(str_c("https://www.lagou.com/zhaopin/shujufenxi/",i),encoding="UTF-8")#read_html函数解析网页并规定编码str_c函数对页数循环
  job<-web%>%html_nodes("h2")%>%html_text()#"h2"即为Selectorgadget定位节点信息
  job[16]<-NA
  job<-job[!is.na(job)]#将多余信息设置为NA并剔除
  #以此类推，抓取岗位其他信息
  company<-web%>%html_nodes(".company_name a")%>%html_text()
  inf1<-web%>%html_nodes(".p_bot .li_b_l")%>%html_text()
  inf2<-web%>%html_nodes(".industry")%>%html_text()
  temptation<-web%>%html_nodes(".li_b_r")%>%html_text()
  job_inf<-data.frame(job,company,inf1,inf2,temptation)
  lagou_data<-rbind(lagou_data,job_inf)
}
write.csv(job_inf,file="D:/Rdata/datasets/job_inf.csv")#写入数据




library("xml2")
library("rvest")
library("dplyr")
library("stringr")

#对爬取页数进行设定并创建数据框
i<-1:100
house_inf<-data.frame()


web <- "https://bj.lianjia.com/ershoufang/haidian/rs%E6%B5%B7%E6%B7%80/" #北京海淀区附近的二手房

house_name <- web %>% html_nodes(xpath = "//div[@class = 'houseInfo']/a") %>% html_text()
house_basic_inf <- web %>% html_nodes(xpath = "//div[@class = 'houseInfo']") %>% html_text()
house_address <- web %>% html_nodes(xpath = "//div[@class = 'positionInfo']/a") %>% html_text()
house_totalprice <- web %>% html_nodes(xpath = "//div[@class = 'totalPrice']")%>%html_text()
house_unitprice <- web %>% html_nodes(xpath = "//div[@class = 'unitPrice']/span")%>%html_text()
house_link <- web %>% html_nodes(xpath = "//div[@class='title']/a") %>% html_attr("href")


#使用for循环进行批量数据爬取（发现url的规律，写for循环语句）
for (i in 1:100){
  web<- read_html(str_c("https://bj.lianjia.com/ershoufang/haidian/pg",i,"rs%E6%B5%B7%E6%B7%80/"),encoding="UTF-8")
  #小区名称
  house_name <- web %>% html_nodes(xpath = "//div[@class = 'houseInfo']/a") %>% html_text()
  #爬取二手房基本信息并消除空格
  house_basic_inf <- web %>% html_nodes(xpath = "//div[@class = 'houseInfo']") %>% html_text()
  house_basic_inf<-str_replace_all(house_basic_inf," ","")
  #地址
  house_address <- web %>% html_nodes(xpath = "//div[@class = 'positionInfo']/a") %>% html_text()
  #SelectorGadget定位节点信息爬取总价
  house_totalprice <- web %>% html_nodes(xpath = "//div[@class = 'totalPrice']")%>%html_text()
  #SelectorGadget定位节点信息爬取单价
  house_unitprice <- web %>% html_nodes(xpath = "//div[@class = 'unitPrice']/span")%>%html_text()
  #爬取房子链接，以便进一步获取信息
  house_link <- web %>% html_nodes(xpath = "//div[@class='title']/a") %>% html_attr("href")
  
  #创建数据框存储以上信息
  house<-data_frame(house_name,house_basic_inf,house_address,house_totalprice,house_unitprice,house_link)
  house_inf<-rbind(house_inf,house)
}