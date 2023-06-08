package com.lc.crm.workbench.web.controller;

import com.lc.crm.commons.contants.Contants;
import com.lc.crm.commons.domain.ReturnObject;
import com.lc.crm.commons.utils.DateUtils;
import com.lc.crm.commons.utils.HSSFUtils;
import com.lc.crm.commons.utils.UUIDUtils;
import com.lc.crm.settings.domain.User;
import com.lc.crm.settings.service.UserService;
import com.lc.crm.workbench.domain.Activity;
import com.lc.crm.workbench.domain.ActivityRemark;
import com.lc.crm.workbench.domain.PaJinSen;
import com.lc.crm.workbench.service.ActivityRemarkService;
import com.lc.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {


    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){

        List<User> userList=userService.queryAllUsers();
        request.setAttribute("userList", userList);
        return "workbench/activity/index";
    }
    @Transactional()
    @ResponseBody
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public ReturnObject saveCreateActivity(PaJinSen paJinSen, HttpSession session){
        System.out.println("名字："+paJinSen.getName());
        System.out.println("年龄："+paJinSen.getAge());
        System.out.println("流涎情况："+paJinSen.getLiuyanqingkuang());
        System.out.println("吞咽情况"+paJinSen.getTunyanqingkuang());
        System.out.println("智力损害："+paJinSen.getZhilisunhai());
        System.out.println("思维障碍："+paJinSen.getSiweizhangai());

        System.out.println("抑郁程度："+paJinSen.getYiyuchengdu());
        System.out.println("言语表达情况："+paJinSen.getYanyubiaodaqingkuang());

        System.out.println("面部表情情况："+paJinSen.getMianbubiaoqingqingkuang());
        ReturnObject returnObject=new ReturnObject();
        returnObject.setCode("1");
        return returnObject;






//        封装参数

//        ReturnObject returnObject=new ReturnObject();
//        User user=(User)session.getAttribute(Contants.SESSION_USER);
//        activity.setId(UUIDUtils.getUUID());
//        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
//        activity.setCreateBy(user.getId());
//        try {
//            int ret=activityService.saveCreatActivity(activity);
//            if(ret>0){
//                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
//            }else{
//                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
//                returnObject.setMessage("系统忙，请稍后重试......");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
//            returnObject.setMessage("系统忙，请稍后重试......");
//        }


//        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public Object queryActivityByConditionForPage(String owner,String name,String startDate,String endDate,
                                                  int pageNO,int pageSize){
//       封装参数
        HashMap map=new HashMap();
        map.put("owner", owner);
        map.put("name", name);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNO-1)*pageSize);
        map.put("pageSize",pageSize);
//调用Service方法
        List<Activity> activitylist=activityService.queryActivityByConditionForPage(map);
        int totalRows=activityService.queryCountOfActivityByCondition(map);
//        根据查询结果生成相应信息
        Map<String,Object>retMap=new HashMap<>();
        retMap.put("activitylist", activitylist);
        retMap.put("totalRows", totalRows);
        return retMap;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/deleteActivityIds.do")
    public Object deleteActivityIds(String[] id){
        ReturnObject returnObject =new ReturnObject();
        int ret= 0;
        try {
            ret = activityService.deleteActivityByIds(id);
            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试.....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试.....");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
//        调用service层的方法
        Activity activity=activityService.queryActivityById(id);
//        根据查询结果，返回相应信息
        return activity;
    }
    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(Activity activity,HttpSession session){
        User user=(User)session.getAttribute(Contants.SESSION_USER);
        activity.setEditTime(DateUtils.formateDateTime(new Date()));
        activity.setEditBy(user.getId());

//      调用Service层方法，保存修改的市场活动
        ReturnObject returnObject=new ReturnObject();
        try {
            int ret=activityService.saveEditActivity(activity);
            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试.....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试.....");
        }
        return returnObject;
    }

//  批量导出市场活动
    @RequestMapping("/workbench/activity/exportAllActivitys.do")
    public void exportAllActivitys(HttpServletResponse response) throws Exception{
//        调用Service层方法，查询所有的市场活动
        List<Activity> activityList =activityService.queryAllActivitys();
//        创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb=new HSSFWorkbook();
        HSSFSheet sheet= wb.createSheet("市场活动列表");
        HSSFRow row= sheet.createRow(0);
        HSSFCell cell=row.createCell(0);
        cell.setCellValue("ID");
        cell=row.createCell(1);
        cell.setCellValue("所有者");
        cell=row.createCell(2);
        cell.setCellValue("名称");
        cell=row.createCell(3);
        cell.setCellValue("开始日期");
        cell=row.createCell(4);
        cell.setCellValue("结束日期");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");
//      遍历activityList，创建HSSFRow对象，生成所有的数据行
        if(activityList!=null && activityList.size()>0){
            Activity activity=null;
            for (int i=0;i<activityList.size();i++){
                row= sheet.createRow(i+1);
                activity=activityList.get(i);
//          每一行创建11列，每一列的数据从activity中获取
                cell=row.createCell(0);
                cell.setCellValue(activity.getId());
                cell=row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell=row.createCell(2);
                cell.setCellValue(activity.getName());
                cell=row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell=row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell=row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell=row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell=row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell=row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell=row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell=row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
//      根据wb对象生成excel文件，这里是吧文件先下载到了服务器磁盘上
//        OutputStream os=new FileOutputStream("D:\\IDEA\\Test\\activityList.xls");
//        wb.write(os);
//        wb.close();
//        os.close();

//      把生成的excel文件下载到客户端,application/octet-stream设置了传递到前端的是什么格式的信息
        response.setContentType("application/octet-stream;charset=UTF-8");
//      设置响应头信息
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");
//      创建输出流，向前端输出数据
        OutputStream out=response.getOutputStream();
//      创建输入流，从服务器的磁盘中读入数据
//        InputStream is=new FileInputStream("D:\\IDEA\\Test\\activityList.xls");
//        byte[] buff=new byte[256];
//        int len=0;
//        while((len=is.read(buff))!=-1){
//            out.write(buff, 0, len);
//        }
        wb.write(out);
        wb.close();
        out.flush();
    }
    //选择导出市场活动
    @RequestMapping("/workbench/activity/querySomeActivitys.do")
    public void querySomeActivitys(String[] ids,HttpServletResponse response) throws Exception{
        //        调用Service层方法，查询所有的市场活动
        System.out.println("[][][][][][][][]");
        System.out.println(ids);
//        String[] ids = s.split("&");
        System.out.println("==================================");
        System.out.println(ids[0]);
        System.out.println(ids[1]);
        List<Activity> activityList =activityService.querySomeActivitys(ids);
        System.out.println("----------------------------------");
//        创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb=new HSSFWorkbook();
        HSSFSheet sheet= wb.createSheet("市场活动列表");
        HSSFRow row= sheet.createRow(0);
        HSSFCell cell=row.createCell(0);
        cell.setCellValue("ID");
        cell=row.createCell(1);
        cell.setCellValue("所有者");
        cell=row.createCell(2);
        cell.setCellValue("名称");
        cell=row.createCell(3);
        cell.setCellValue("开始日期");
        cell=row.createCell(4);
        cell.setCellValue("结束日期");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");
//      遍历activityList，创建HSSFRow对象，生成所有的数据行
        if(activityList!=null && activityList.size()>0){
            Activity activity=null;
            for (int i=0;i<activityList.size();i++){
                row= sheet.createRow(i+1);
                activity=activityList.get(i);
//          每一行创建11列，每一列的数据从activity中获取
                cell=row.createCell(0);
                cell.setCellValue(activity.getId());
                cell=row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell=row.createCell(2);
                cell.setCellValue(activity.getName());
                cell=row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell=row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell=row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell=row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell=row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell=row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell=row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell=row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
//      根据wb对象生成excel文件，这里是吧文件先下载到了服务器磁盘上
//        OutputStream os=new FileOutputStream("D:\\IDEA\\Test\\activityList.xls");
//        wb.write(os);
//        wb.close();
//        os.close();

//      把生成的excel文件下载到客户端,application/octet-stream设置了传递到前端的是什么格式的信息
        response.setContentType("application/octet-stream;charset=UTF-8");
//      设置响应头信息
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");
//      创建输出流，向前端输出数据
        OutputStream out=response.getOutputStream();
//      创建输入流，从服务器的磁盘中读入数据
//        InputStream is=new FileInputStream("D:\\IDEA\\Test\\activityList.xls");
//        byte[] buff=new byte[256];
//        int len=0;
//        while((len=is.read(buff))!=-1){
//            out.write(buff, 0, len);
//        }
        wb.write(out);
        wb.close();
        out.flush();
    }


//  导入市场活动
    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,HttpSession session){
        User user=(User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject =new ReturnObject();

        try {
            /*
            下面这个是低效的写法，因为牵扯到了从磁盘里面读入和写入数据
            * */
////          把excel文件写道磁盘目录中
//            String originalFileName = activityFile.getOriginalFilename();
//            File file =new File("D:\\IDEA\\Test", originalFileName);
//            activityFile.transferTo(file);
////          解析excel文件，获取文件中的数据，并且封装成activityList
//            InputStream is =new FileInputStream("D:\\IDEA\\Test\\"+originalFileName);

            /*
            * 下面这个是高效的写法
            * */
            InputStream is=activityFile.getInputStream();
            HSSFWorkbook wb=new HSSFWorkbook(is);
//          根据wb获取HSSFSheet对象，封装了一页的所有信息
            HSSFSheet sheet=wb.getSheetAt(0);
//          根据sheet获取HSSFRow对象，封装了一行的所有信息
            HSSFRow row=null;
            HSSFCell cell=null;
            Activity activity=null;
            List<Activity> activityList =new ArrayList<>();
            for (int i=1;i<=sheet.getLastRowNum();i++){
//              这里的row是每一行,row包含了一行中的所有数据
                row=sheet.getRow(i);
                activity=new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                activity.setCreateBy(user.getId());

                for(int j=0;j<row.getLastCellNum();j++){
//                  这里是获得每一行的每一列的数据，cell包含了一列中的所有数据
                    cell=row.getCell(j);
//                  将每一列的数据封装到activity对象中
                    String cellValue=HSSFUtils.getCellValueForStr(cell);
                    if(j==0){
                        activity.setName(cellValue);
                    }else if(j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2){
                        activity.setEndDate(cellValue);
                    }else if(j==3){
                        activity.setCost(cellValue);
                    }else if(j==4){
                        activity.setDescription(cellValue);
                    }

                }
//              把市场活动保存在LIST中
                activityList.add(activity);

            }
//          d调用Service方法，保存list
            int ret=activityService.saveCreateActivityByList(activityList);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(ret);
        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试........");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request){
        System.out.println("======="+id+"============");
        Activity activity=activityService.queryActivityById(id);
        System.out.println("======================");
        List<ActivityRemark> remarklist=activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        System.out.println("..............................");
        request.setAttribute("activity", activity);
        request.setAttribute("remarklist",remarklist );
        return "workbench/activity/detail";

    }
}
