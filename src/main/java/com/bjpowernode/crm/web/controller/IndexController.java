package com.bjpowernode.crm.web.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class IndexController {

//    这个接下来的方法是SpringMvc核心控制器进行调用的，所以方法权限设置为public
//理论上为：@RequestMapping("http://127.0.0.1:8080/crm/")实际上：@RequestMapping("/")，原因是省略的那些内容都是所有的url共同的部分必须省略
    @RequestMapping("/")
    public String index(){
//      这里应该是用请求转发，如果要是用重定向的话，浏览器的地址会发生变化，我们这里不希望浏览器地址发生变化
        return "index";

    }
}
