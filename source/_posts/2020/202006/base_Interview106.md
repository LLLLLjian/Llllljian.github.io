---
title: Interview_总结 (106)
date: 2020-06-12
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### PHP实现前序遍历二叉树
- 前序遍历
    * 根左右213
```php
    class Node
    {
        public $value;
        public $left;
        public $right;
    }

    function preorder($root)
    {
        if (!empty($root)) {
            echo $root->value;
            preorder($root->left);
            preorder($root->right); 
        }
    }

    function preorder1($root)
    {
        $stack=array();
        array_push($stack,$root);
        while(!empty($stack)){
            $center_node=array_pop($stack);
            echo $center_node->value.' ';//先输出根节点
            if($center_node->right!=null){
                array_push($stack,$center_node->right);//压入左子树
            }
            if($center_node->left!=null){
                array_push($stack,$center_node->left);
            }
        }
    }

    $a=new Node();
    $b=new Node();
    $c=new Node();
    $d=new Node();
    $e=new Node();
    $f=new Node();
    $a->value='A';
    $b->value='B';
    $c->value='C';
    $d->value='D';
    $e->value='E';
    $f->value='F';
    $a->left=$b;
    $a->right=$c;
    $b->left=$d;
    $c->left=$e;
    $c->right=$f;

    preorder($a);//A B D C E F 
    echo "<br />";
    preorder1($a);//A B D C E F 
```

#### PHP实现中序遍历二叉树
- 中序遍历
    * 左根右123
```php
    function inorder($root)
    {
        if (!empty($root)) {
            inorder($root->left);
            echo $root->value;
            inorder($root->right);
        }
    }

    function inorder1($root)
    {
        $stack = array();
        $center_node = $root;
        while (!empty($stack) || $center_node != null) {
            while ($center_node != null) {
                array_push($stack, $center_node);
                $center_node = $center_node->left;
            }
            $center_node = array_pop($stack);
            echo $center_node->value . " ";
            $center_node = $center_node->right;
        }
    }
```

#### PHP实现后序遍历二叉树
- 后序遍历
    * 左右根132
```php
    function tailorder($root)
    {
        if (!empty($root)) {
            tailorder($root->left);
            tailorder($root->right);
            echo $root->value;
        }
    }

    function tailorder1($root)
    {
        $stack=array();
        $outstack=array();
        array_push($stack,$root);
        while(!empty($stack)){
            $center_node=array_pop($stack);
            array_push($outstack,$center_node);//最先压入根节点, 最后输出
            if($center_node->left!=null){
                array_push($stack,$center_node->left);
            }
            if($center_node->right!=null){
                array_push($stack,$center_node->right);
            }
        }

        while(!empty($outstack)){
            $center_node=array_pop($outstack);
            echo $center_node->value.' ';
        }
    }
```
