package com.bjpowernode.crm.workbench;

import java.util.Date;

public class MyThread extends Thread{

    public MyThread(String s){
        Thread.currentThread().setName(s);
    }

    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + " Start. Time = " + new Date());
    }
}

