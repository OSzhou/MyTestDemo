defineClass('ViewController', {
            handleBtn: function(sender) {
            var tableViewCtrl = FMTableViewController.alloc().init()
            self.navigationController().pushViewController_animated(tableViewCtrl, YES)
            }
            })

defineClass('FMTableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
            dataSource: function() {
            var data = self.data();
            if (data) return data;//判断数组是否存在
            var data = [];//数组初始化
            for (var i = 0; i < 20; i ++) {
            data.push("cell from js " + i);//push(要放入的元素):向数组里添加元素。join('元素之间用什么连接'):将数组里的所有元素放入一个字符串
            }
            self.setData(data)
            return data;
            },
            numberOfSectionsInTableView: function(tableView) {
            return 1;
            },
            tableView_numberOfRowsInSection: function(tableView, section) {
            return self.dataSource().length;
            },
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
            if (!cell) {
            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
            }
            cell.textLabel().setText(self.dataSource()[indexPath.row()])
            return cell
            },
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
            return 60
            },
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
            alertView.show()
            },
            alertView_willDismissWithButtonIndex: function(alertView, idx) {
            console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
            }
            })
