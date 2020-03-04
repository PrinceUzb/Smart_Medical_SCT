$ ->
  my.initAjax()

  Glob = window.Glob || {}

  apiUrl =
    send: '/addOrganization'
    get: '/getOrganization'
    delete: '/deleteOrganization'
    update: '/updateOrganization'

  vm = ko.mapping.fromJS
    organizationName: ''
    phoneNumber: ''
    address: ''
    email: ''
    workersNumber: ''
    workType: []
    selectedDepartment: []
    departmentList: [{id: 1, workType: 'workType1'}, {id: 2, workType: 'workType2'}, {id: 3, workType: 'workType3'}]
    user: defaultUserdata
    organizations: []
    roleList: []
    id: 0
    after: ''
    language: Glob.language
    selected:
      id: ''
      name: ''

  defaultUserdata =
    selectedRoles: []

  handleError = (error) ->
    if error.status is 500 or (error.status is 400 and error.responseText) or error.status is 200
      toastr.error(error.responseText)
    else
      toastr.error('Something went wrong! Please try again.')

  vm.onSubmit = ->
    console.log(vm.selectedDepartment())
    toastr.clear()
    if (!vm.organizationName())
      toastr.error("Please enter a Organization Name")
      return no
    else if (!vm.phoneNumber())
      toastr.error("Please enter a phone number")
      return no
    else if (!vm.address())
      toastr.error("Please enter a address")
      return no
    else if (!vm.email())
      toastr.error("Please enter a email")
      return no
    else if (vm.selectedDepartment().length is 0)
      toastr.error("Please enter a Department")
      return no
    else
      data =
        organizationName: vm.organizationName()
        phoneNumber: vm.phoneNumber()
        address: vm.address()
        email: vm.email()
        department: vm.selectedDepartment()
      $.ajax
        url: apiUrl.send
        type: 'POST'
        data: JSON.stringify(data)
        dataType: 'json'
        contentType: 'application/json'
      .fail handleError
      .done (response) ->
        toastr.success(response)
        $("#organization").click()



#  getOrganization = ->
#    $.ajax
#      url: apiUrl.get
#      type: 'GET'
#    .fail handleError
#    .done (response) ->
#      vm.organizations(response)
#
#  getOrganization()


  vm.askDelete = (id) -> ->
    vm.selected.id id
    $('#delete').open

  vm.openEditForm = (data) -> ->
    vm.selected.id data.id
    vm.selected.name(data.organizationName)
    $('#edit_lab_type').open

  vm.deleteOrg = ->
    data =
      id: vm.selected.id()
    $.ajax
      url: apiUrl.delete
      type: 'DELETE'
      data: JSON.stringify(data)
      dataType: 'json'
      contentType: 'application/json'
    .fail handleError
    .done (response) ->
      $('#close_delete_modal').click()
      toastr.success(response)
      getOrganization()
#    $(this).parents('tr').remove()

  vm.updateOrganization = ->
    data =
      id: vm.selected.id()
      organizationName: vm.selected.name()
    $.ajax
      url: apiUrl.update
      type: 'POST'
      data: JSON.stringify(data)
      dataType: 'json'
      contentType: 'application/json'
    .fail handleError
    .done (response) ->
      $("#closeEditModal").click()
      toastr.success(response)
      getOrganization()

  $(document).on 'click', '.clickOnRow', ->
    row = $(this).closest('tr')
    if row.next('tr').hasClass('hide')
      row.next('tr').show().removeClass('hide').addClass('show')
    else
      row.next('tr').hide().removeClass('show').addClass('hide')


  vm.translate = (fieldName) -> ko.computed () ->
    index = if vm.language() is 'en' then 0 else 1
    vm.labels[fieldName][index]

  vm.labels =
    label: [
      "Hello World!"
      "Salom Dunyo!"
    ]

  ko.applyBindings {vm}
