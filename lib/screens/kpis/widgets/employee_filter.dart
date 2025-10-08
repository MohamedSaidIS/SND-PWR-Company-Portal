import 'package:company_portal/models/remote/group_member.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_info_provider.dart';

class EmployeeFilter extends StatefulWidget {
  final GroupMember selectedEmployee;
  final ValueChanged<GroupMember> onEmployeeChanged;

  const EmployeeFilter({
    super.key,
    required this.selectedEmployee,
    required this.onEmployeeChanged,
  });

  @override
  State<EmployeeFilter> createState() => _EmployeeFilterState();
}

class _EmployeeFilterState extends State<EmployeeFilter> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = context.watch<UserInfoProvider>();
    final employees = userInfoProvider.groupMembers ?? [];
    final theme = context.theme;

    // تأكد إن selectedEmployee.memberId موجود فعلاً داخل القائمة
    final selectedValue = employees.any((e) => e.memberId == widget.selectedEmployee.memberId)
        ? widget.selectedEmployee.memberId
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: DropdownButton2<String>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text('اختر الموظف'),
          value: selectedValue,
          onChanged: (val) {
            final selected = employees.firstWhere((e) => e.memberId == val);
            widget.onEmployeeChanged(selected);
          },
          items: employees.map((emp) {
            return DropdownMenuItem<String>(
              value: emp.memberId,
              child: Text(emp.displayName ?? '', style: const TextStyle(fontSize: 14),),
            );
          }).toList(),

          dropdownSearchData: DropdownSearchData(
            searchController: searchController,
            searchInnerWidgetHeight: 20,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  hintText: 'ابحث عن موظف...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final employee = employees.firstWhere(
                    (e) => e.memberId == item.value,
                orElse: () => GroupMember(
                    memberId: '',
                    displayName: '',
                    givenName: '',
                    surname: '',
                    mail: '',
                    jobTitle: ''),
              );

              return (employee.displayName ?? '')
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),

          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
          },
        ),
      ),
    );
  }
}
