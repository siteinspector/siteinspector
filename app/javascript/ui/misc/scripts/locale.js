import locale from 'view-design/src/locale'
import en from 'view-design/src/locale/lang/en-US'

locale.use(Object.assign(en, {
  marked_as_resolved: 'Marked as Resolved',
  marked_as_pending: 'Marked as Pending',
  marked_as_excluded: 'Marked as Excluded'
}))

export default locale
