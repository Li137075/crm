package com.lc.crm.workbench.service;

import com.lc.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String id);

// 返回保存市场活动备注的影响记录条数
    int saveCreateActivityRemark(ActivityRemark remark);

// 删除市场活动的备注信息
    int deleteActivityRemarkById(String id);

// 修改市场活动的备注信息
    int saveEditActivityRemark(ActivityRemark remark);
}
