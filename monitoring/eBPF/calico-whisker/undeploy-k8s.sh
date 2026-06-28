#!/bin/bash

NS=kube-system

kubectl -n $NS delete serviceaccount goldmane
kubectl -n $NS delete service goldmane
kubectl -n $NS delete configmap goldmane
kubectl -n $NS delete deployment goldmane

kubectl -n $NS delete serviceaccount whisker
kubectl -n $NS delete service whisker
kubectl -n $NS delete deployment whisker
kubectl -n $NS delete certificate whisker-cert
kubectl -n $NS delete httpproxy whisker-httpproxy
