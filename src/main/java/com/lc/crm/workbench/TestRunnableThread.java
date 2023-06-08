package com.lc.crm.workbench;

public class TestRunnableThread {
    public static void main(String[] args) {
        MyRunnableThread m=new MyRunnableThread();
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
