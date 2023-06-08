package com.lc.crm.workbench;

public class TestThread {
    public static void main(String[] args) {
        MyThread m=new MyThread("skl");
        Thread t1=new Thread(m);
        Thread t2=new Thread(m);
        Thread t3=new Thread(m);
        t1.setName("线程1");
        t2.setName("线程2");
        t3.setName("线程3");
        t1.start();
        t2.start();
        t3.start();
    }
}
