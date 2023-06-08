package com.lc.crm.workbench;

public class MyRunnableThread implements Runnable{

    private int total=100;

    @Override
    public void run() {
        while(total>0){
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            String name=Thread.currentThread().getName();
            System.out.println(name+"剩余数量"+total);
            total--;
        }

    }
}
