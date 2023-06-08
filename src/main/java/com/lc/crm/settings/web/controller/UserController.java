package com.lc.crm.settings.web.controller;

import com.lc.crm.commons.contants.Contants;
import com.lc.crm.commons.domain.ReturnObject;
import com.lc.crm.commons.utils.DateUtils;
import com.lc.crm.settings.domain.User;
import com.lc.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


@Controller
public class UserController {

    @Autowired
    private UserService userService;
    /*这里的url要和当前Contoller方法处理*/
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
//请求转发到登录页面
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
//        封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
//        调用Service方法
        User user=userService.queryUserByLoginActAndPwd(map);
        System.out.println(user);
//        根据查询结果生成相应信息
        ReturnObject returnObject=new ReturnObject();
        if(user==null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或者密码错误");
//进一步判断账号是否合法
        }else{
            String nowStr=DateUtils.formateDateTime(new Date());
            if(nowStr.compareTo(user.getExpireTime())>0){
//                登录失败，账号已经过期
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已过期");
            }else if("0".equals(user.getLockState())){
//                登录失败，状态被锁定
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("状态被锁定");
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
//                登录失败，IP受限制
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("ip受限");
            }else{
//                登录成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
//                把user保存到session作用域中
                session.setAttribute(Contants.SESSION_USER, user);
//              如果需要记住密码，往外写cookie
                if("true".equals(isRemPwd)){
                    Cookie c1=new Cookie("loginAct", user.getLoginAct());
                    c1.setMaxAge(10*24*60*60);
                    System.out.println(1);
                    response.addCookie(c1);
                    Cookie c2=new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c2);
                }else{
//                    删除没有过期的cookie
                    Cookie c1=new Cookie("loginAct", "1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    System.out.println(2);
                    Cookie c2=new Cookie("loginPwd", "2");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;

    }
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
//      清空cookie
        Cookie c1=new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        System.out.println(2);
        Cookie c2=new Cookie("loginPwd", "2");
        c2.setMaxAge(0);
        response.addCookie(c2);
//      销毁session
        session.invalidate();
//      跳转到首页
        return "redirect:/";
    }
}
