import { useEffect, useMemo, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import DashboardSkeleton from '../components/DashboardSkeleton';
import { ProfileMenu } from '../components/shared.jsx';
import * as apiService from '../services/apiService';
import logo from '../assets/Logo1.png';
import './SportTeacherPage.css';
import '../styles/districtmanager.css';

const EyeIcon = ({ visible = false }) => (
  <svg viewBox="0 0 24 24" aria-hidden="true">
    {visible ? <><path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" /><circle cx="12" cy="12" r="2.5" /></> : <><path d="M3 3l18 18" /><path d="M10.6 6.2A10.8 10.8 0 0 1 12 6c6.5 0 10 6 10 6a18.5 18.5 0 0 1-3.1 3.7M6.2 6.8C3.5 8.4 2 12 2 12s3.5 6 10 6a10.7 10.7 0 0 0 4-.8" /></>}
  </svg>
);

const MENU_ITEMS = [
  { key: 'home', label: 'Home' },
  { key: 'registered-schools', label: 'Registered Schools' },
  { key: 'school-results', label: 'School-level results' },
  { key: 'promoted-school-results', label: 'SchoolResults' },
  { key: 'district-results', label: 'District-level results' },
  { key: 'district-archive-results', label: 'DistrictResults' },
  { key: 'register-school', label: 'Register School' },
  { key: 'announcements', label: 'Announcements' },
];

export default function DistrictManagerPage() {
  const { logout } = useAuth();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);
  const [selectedDistrict, setSelectedDistrict] = useState('');
  const [allDistricts, setAllDistricts] = useState([]);
  const [schools, setSchools] = useState([]);
  const [wards, setWards] = useState([]);
  const [schoolOwnershipTypes, setSchoolOwnershipTypes] = useState([]);
  const [schoolRegistrationSubmitting, setSchoolRegistrationSubmitting] = useState(false);
  const [editingSchoolId, setEditingSchoolId] = useState(null);
  const [schoolEditForm, setSchoolEditForm] = useState({
    registry_number: '',
    name: '',
    ownership_type: '',
    ward: '',
    phone: '',
    physical_address: '',
    email: '',
  });
  const [schoolManagementSubmitting, setSchoolManagementSubmitting] = useState(false);

  const [schoolRegistrationForm, setSchoolRegistrationForm] = useState({
    registry_number: '',
    name: '',
    ownership_type: '',
    ward: '',
    phone: '',
    physical_address: '',
    email: '',
  });
  const [competitions, setCompetitions] = useState([]);
  const [students, setStudents] = useState([]);
  const [studentTalents, setStudentTalents] = useState([]);
  const [clubMemberships, setClubMemberships] = useState([]);
  const [educationLevels, setEducationLevels] = useState([]);
  const [announcements, setAnnouncements] = useState([]);
  const [results, setResults] = useState([]);
  const [participations, setParticipations] = useState([]);
  const [promotions, setPromotions] = useState([]);
  const [resultDetails, setResultDetails] = useState([]);
  const [selectedSchoolStudents, setSelectedSchoolStudents] = useState([]);
  const [selectedResultStudents, setSelectedResultStudents] = useState([]);
  const [announcementForm, setAnnouncementForm] = useState({ title: '', content: '', published_at: '', expires_at: '', audience: 'both' });
  const [selectedAnnouncement, setSelectedAnnouncement] = useState(null);
  const [announcementDrawerOpen, setAnnouncementDrawerOpen] = useState(false);
  const [announcementSubmitting, setAnnouncementSubmitting] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [submittingSchoolCompetitionId, setSubmittingSchoolCompetitionId] = useState(null);
  const [submittingDistrictCompetitionId, setSubmittingDistrictCompetitionId] = useState(null);
  const [selectedPromotionStudents, setSelectedPromotionStudents] = useState([]);
  const [promotionStudentLimit, setPromotionStudentLimit] = useState('');
  const [selectedDemotionDetails, setSelectedDemotionDetails] = useState([]);
  const [selectedDistrictCompetitionId, setSelectedDistrictCompetitionId] = useState('');
  const [activeMenu, setActiveMenu] = useState('home');
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [profileMenuOpen, setProfileMenuOpen] = useState(false);
  const [schoolSubmissions, setSchoolSubmissions] = useState([]);
  const [districtSubmissions, setDistrictSubmissions] = useState([]);
  const [selectedCompetition, setSelectedCompetition] = useState(null);
  const [competitionDrawerOpen, setCompetitionDrawerOpen] = useState(false);
  const [competitionDrawerWidth, setCompetitionDrawerWidth] = useState(420);
  const [isResizingCompetitionDrawer, setIsResizingCompetitionDrawer] = useState(false);
  const [competitionForm, setCompetitionForm] = useState({ name: '', description: '', venue: '', start_date: '', end_date: '', talent: '' });
  const [competitionSubmitting, setCompetitionSubmitting] = useState(false);
  const [profileDrawerOpen, setProfileDrawerOpen] = useState(false);
  const [profileEmail, setProfileEmail] = useState('');
  const [profilePhone, setProfilePhone] = useState('');
  const [profileMessage, setProfileMessage] = useState(null);
  const [passwordDrawerOpen, setPasswordDrawerOpen] = useState(false);
  const [profilePasswordForm, setProfilePasswordForm] = useState({ new_password: '', confirm_password: '' });
  const [showProfilePassword, setShowProfilePassword] = useState(false);
  const [showProfilePasswordConfirmation, setShowProfilePasswordConfirmation] = useState(false);
  const [profileSubmitting, setProfileSubmitting] = useState(false);
  const [calendarDate, setCalendarDate] = useState(() => new Date());
  const showSuccess = (message) => {
    setSuccess(message);
    window.setTimeout(() => setSuccess(null), 4000);
  };

  const districtName = currentUser?.district_name
    || allDistricts.find((district) => Number(district.id) === Number(selectedDistrict))?.name
    || 'Assigned District';

  useEffect(() => {
    if (!isResizingCompetitionDrawer) return undefined;
    const handlePointerMove = (event) => {
      const nextWidth = window.innerWidth - event.clientX;
      setCompetitionDrawerWidth(Math.max(320, Math.min(nextWidth, Math.min(760, window.innerWidth - 24))));
    };
    const stopResizing = () => setIsResizingCompetitionDrawer(false);
    window.addEventListener('pointermove', handlePointerMove);
    window.addEventListener('pointerup', stopResizing);
    return () => {
      window.removeEventListener('pointermove', handlePointerMove);
      window.removeEventListener('pointerup', stopResizing);
    };
  }, [isResizingCompetitionDrawer]);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        setLoading(true);
        setError(null);

        const [userRes, districtsRes, schoolsRes, wardsRes, competitionsRes, studentsRes, talentsRes, clubMembershipsRes, educationLevelsRes, announcementsRes, resultsRes, participationsRes, promotionsRes, resultDetailsRes, submissionsRes, districtSubmissionsRes] = await Promise.all([
          apiService.getCurrentUser(),
          apiService.getDistricts(),
          apiService.getSchools(),
          apiService.getWards(),
          apiService.getAllCompetitions(),
          apiService.getAllStudents(),
          apiService.getStudentTalents(),
          apiService.getClubMemberships(),
          apiService.getEducationLevels({ is_active: true }),
          apiService.getAnnouncements({ is_active: true }),
          apiService.getAllResults(),
          apiService.getAllParticipations(),
          apiService.getAllResultPromotions(),
          apiService.getAllResultDetails(),
          apiService.getAllSchoolResultSubmissions(),
          apiService.getAllDistrictResultSubmissions(),
        ]);

        const districtList = districtsRes.data.results || [];
        const schoolList = schoolsRes.data.results || [];
        const wardList = wardsRes.data.results || [];
        const competitionList = competitionsRes.data.results || [];
        const studentList = studentsRes.data.results || [];
        const talentList = talentsRes.data.results || [];
        const announcementList = announcementsRes.data.results || [];

        setCurrentUser(userRes.data);
        setAllDistricts(districtList);
        setSchools(schoolList);
        setWards(wardList);
        setCompetitions(competitionList);
        setStudents(studentList);
        setStudentTalents(talentList);
        setClubMemberships(clubMembershipsRes.data.results || []);
        setEducationLevels(educationLevelsRes.data.results || []);
        setAnnouncements(announcementList);
        setResults(resultsRes.data.results || []);
        setParticipations(participationsRes.data.results || []);
        setPromotions(promotionsRes.data.results || []);
        setResultDetails(resultDetailsRes.data.results || []);
        setSchoolSubmissions(submissionsRes.data.results || []);
        setDistrictSubmissions(districtSubmissionsRes.data.results || []);

        const defaultDistrict = userRes.data?.district || districtList[0]?.id || '';
        setSelectedDistrict(String(defaultDistrict));
      } catch (err) {
        console.error('Error fetching district dashboard:', err);
        setError(err.response?.data?.detail || 'Failed to load dashboard data');
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, []);


  useEffect(() => {
    let mounted = true;

    apiService.getSchoolOwnershipTypes()
      .then((response) => {
        const data = response.data;
        const items = Array.isArray(data) ? data : (data?.results || []);
        if (mounted) setSchoolOwnershipTypes(items);
      })
      .catch((err) => {
        console.error('Failed to load school ownership types:', err);
      });

    return () => {
      mounted = false;
    };
  }, []);

  const updateSchoolRegistrationField = (field, value) => {
    setSchoolRegistrationForm((previous) => ({
      ...previous,
      [field]: value,
    }));
  };

  const submitSchoolRegistration = async (event) => {
    event.preventDefault();
    setError(null);
    setSuccess(null);

    const districtId = Number(currentUser?.district);
    if (!districtId) {
      setError('Your account is not assigned to a district. Contact the administrator.');
      return;
    }

    if (!schoolRegistrationForm.name.trim()) {
      setError('Please enter the school name.');
      return;
    }

    if (!schoolRegistrationForm.ownership_type) {
      setError('Please select the school ownership type.');
      return;
    }

    if (!schoolRegistrationForm.ward) {
      setError('Please select the school ward.');
      return;
    }

    const selectedWard = wards.find(
      (ward) =>
        Number(ward.id) === Number(schoolRegistrationForm.ward)
        && Number(ward.district?.id ?? ward.district) === districtId
    );

    if (!selectedWard) {
      setError('Please select a valid ward in your assigned district.');
      return;
    }

    const payload = {
      registry_number: schoolRegistrationForm.registry_number.trim(),
      name: schoolRegistrationForm.name.trim(),
      ownership_type: schoolRegistrationForm.ownership_type,
      district: districtId,
      ward: Number(schoolRegistrationForm.ward),
      phone: schoolRegistrationForm.phone.trim(),
      physical_address: schoolRegistrationForm.physical_address.trim(),
      email: schoolRegistrationForm.email.trim(),
    };

    try {
      setSchoolRegistrationSubmitting(true);
      const response = await apiService.createSchool(payload);

      if (response.data) {
        setSchools((previous) => [
          ...previous.filter((school) => Number(school.id) !== Number(response.data.id)),
          response.data,
        ]);
      }

      setSchoolRegistrationForm({
        registry_number: '',
        name: '',
        ownership_type: '',
        ward: '',
        phone: '',
        physical_address: '',
        email: '',
      });

      showSuccess(
        'School registration submitted successfully. The school is pending Talent Admin approval.'
      );
    } catch (err) {
      console.error('School registration failed:', err);
      const data = err.response?.data;
      let message = data?.detail || data?.error || 'Failed to register school. Please check the details and try again.';

      if (data && typeof data === 'object' && !data.detail && !data.error) {
        const fieldErrors = Object.entries(data)
          .map(([field, value]) => {
            const detail = Array.isArray(value) ? value.join(' ') : String(value);
            return `${field}: ${detail}`;
          })
          .join(' ');
        if (fieldErrors) message = fieldErrors;
      }

      setError(message);
    } finally {
      setSchoolRegistrationSubmitting(false);
    }
  };

  const openSchoolEditor = (school) => {
    setEditingSchoolId(Number(school.id));
    setSchoolEditForm({
      registry_number: school.registry_number || '',
      name: school.name || '',
      ownership_type: school.ownership_type?.name || school.ownership_type || '',
      ward: String(school.ward?.id ?? school.ward ?? ''),
      phone: school.phone || '',
      physical_address: school.physical_address || '',
      email: school.email || '',
    });
    setError(null);
    setSuccess(null);
  };

  const handleUpdateRegisteredSchool = async (event) => {
    event.preventDefault();
    if (!editingSchoolId) return;

    const districtId = Number(currentUser?.district);
    const selectedWard = wards.find(
      (ward) =>
        Number(ward.id) === Number(schoolEditForm.ward) &&
        Number(ward.district?.id ?? ward.district) === districtId
    );

    if (!selectedWard) {
      setError('Please select a valid ward in your assigned district.');
      return;
    }

    const payload = {
      registry_number: schoolEditForm.registry_number.trim(),
      name: schoolEditForm.name.trim(),
      ownership_type: schoolEditForm.ownership_type,
      ward: Number(schoolEditForm.ward),
      phone: schoolEditForm.phone.trim() || null,
      physical_address: schoolEditForm.physical_address.trim(),
      email: schoolEditForm.email.trim() || null,
    };

    setSchoolManagementSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await apiService.patchSchool(editingSchoolId, payload);
      setSchools((current) =>
        current.map((school) =>
          Number(school.id) === editingSchoolId
            ? { ...school, ...response.data }
            : school
        )
      );
      setEditingSchoolId(null);
      showSuccess('School information updated successfully.');
    } catch (err) {
      const data = err.response?.data;
      const fieldErrors = data && typeof data === 'object'
        ? Object.entries(data)
            .map(([field, value]) =>
              `${field}: ${Array.isArray(value) ? value.join(' ') : String(value)}`
            )
            .join(' ')
        : '';

      setError(data?.detail || fieldErrors || 'Failed to update school information.');
    } finally {
      setSchoolManagementSubmitting(false);
    }
  };

  const handleToggleSchoolActive = async (school) => {
    const isCurrentlyActive = school.is_active !== false;
    const actionName = isCurrentlyActive ? 'suspend' : 'activate';

    if (!window.confirm(
      isCurrentlyActive
        ? `Suspend ${school.name}? School users will not be able to log in.`
        : `Activate ${school.name}?`
    )) return;

    setSchoolManagementSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      const response = isCurrentlyActive
        ? await apiService.suspendSchool(school.id)
        : await apiService.activateSchool(school.id);

      const updatedSchool = response.data?.school;
      if (updatedSchool) {
        setSchools((current) =>
          current.map((item) =>
            Number(item.id) === Number(school.id)
              ? { ...item, ...updatedSchool }
              : item
          )
        );
      }

      showSuccess(
        isCurrentlyActive
          ? 'School suspended successfully.'
          : 'School activated successfully.'
      );
    } catch (err) {
      setError(
        err.response?.data?.detail ||
        `Failed to ${actionName} school.`
      );
    } finally {
      setSchoolManagementSubmitting(false);
    }
  };

  const handleDeleteRegisteredSchool = async (school) => {
    if (!window.confirm(
      `Delete ${school.name}? This cannot be undone. Schools with students, user accounts, or competitions cannot be deleted.`
    )) return;

    setSchoolManagementSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      await apiService.deleteSchool(school.id);
      setSchools((current) =>
        current.filter((item) => Number(item.id) !== Number(school.id))
      );
      if (Number(editingSchoolId) === Number(school.id)) {
        setEditingSchoolId(null);
      }
      showSuccess('School deleted successfully.');
    } catch (err) {
      setError(
        err.response?.data?.detail ||
        'Failed to delete school. Suspend it instead if it has related records.'
      );
    } finally {
      setSchoolManagementSubmitting(false);
    }
  };

  const visibleDistrictId = selectedDistrict ? Number(selectedDistrict) : null;

  const districtSchools = useMemo(() => {
    if (!visibleDistrictId) return schools;
    return schools.filter((school) => Number(school.district) === visibleDistrictId);
  }, [schools, visibleDistrictId]);

  const districtWards = useMemo(() => {
    if (!visibleDistrictId) return wards;
    return wards.filter((ward) => Number(ward.district) === visibleDistrictId);
  }, [wards, visibleDistrictId]);

  const districtStudents = useMemo(() => {
    if (!visibleDistrictId) return students;
    const schoolIds = new Set(districtSchools.map((school) => Number(school.id)));
    return students.filter((student) => schoolIds.has(Number(student.school?.id ?? student.school)));
  }, [districtSchools, students, visibleDistrictId]);

  const districtTalents = useMemo(() => {
    if (!visibleDistrictId) return studentTalents;
    const studentIds = new Set(districtStudents.map((student) => Number(student.id)));
    return studentTalents.filter((entry) => studentIds.has(Number(entry.student)));
  }, [districtStudents, studentTalents, visibleDistrictId]);

  const currentZoneId = Number(currentUser?.zone || 0);
  const currentCountryId = Number(currentUser?.country || 0);

  const districtCompetitions = useMemo(() => {
    const districtMatches = competitions.filter((competition) => {
      if (competition.level !== 'district') return false;
      const locationId = competition.object_id ?? competition.district ?? competition.region ?? competition.zone ?? competition.country;
      const isDistrictLocation = Number(locationId) === visibleDistrictId;
      const belongsToDistrictSchool = Array.isArray(competition.schools)
        && competition.schools.some((schoolId) => districtSchools.some((school) => Number(school.id) === Number(schoolId)));
      return isDistrictLocation || belongsToDistrictSchool;
    });

    const zoneMatches = competitions.filter((competition) => {
      if (competition.level !== 'zone') return false;
      const locationId = competition.object_id ?? competition.zone ?? competition.zone_id ?? competition.district ?? competition.region ?? competition.country;
      return Number(locationId) === currentZoneId;
    });

    const countryMatches = competitions.filter((competition) => {
      if (competition.level !== 'country') return false;
      const locationId = competition.object_id ?? competition.country ?? competition.zone ?? competition.region ?? competition.district;
      return Number(locationId) === currentCountryId;
    });

    return [...districtMatches, ...zoneMatches, ...countryMatches].filter((competition, index, items) => {
      const key = Number(competition.id);
      return items.findIndex((item) => Number(item.id) === key) === index;
    });
  }, [competitions, currentCountryId, currentZoneId, districtSchools, visibleDistrictId]);

  const schoolCompetitions = useMemo(() => {
    if (!visibleDistrictId) return competitions.filter((competition) => competition.level === 'school');
    return competitions.filter((competition) => {
      if (competition.level !== 'school') return false;
      const locationId = competition.object_id ?? competition.district ?? competition.region ?? competition.zone ?? competition.country;
      const belongsToDistrictSchool = Array.isArray(competition.schools)
        && competition.schools.some((schoolId) => districtSchools.some((school) => Number(school.id) === Number(schoolId)));
      return Number(locationId) === visibleDistrictId || belongsToDistrictSchool;
    });
  }, [competitions, districtSchools, visibleDistrictId]);
  const districtLevelCompetitions = useMemo(() => districtCompetitions.filter((competition) => competition.level === 'district'), [districtCompetitions]);

  const submittedDistrictCompetitionIds = useMemo(
    () => new Set(
      districtSubmissions
        .filter((submission) =>
          Number(submission.district?.id ?? submission.district) === Number(currentUser?.district)
          && submission.status === 'submitted'
        )
        .map((submission) =>
          Number(submission.competition?.id ?? submission.competition)
        )
    ),
    [currentUser?.district, districtSubmissions]
  );

  const availablePromotionDistrictCompetitions = useMemo(
    () => districtLevelCompetitions.filter(
      (competition) => !submittedDistrictCompetitionIds.has(Number(competition.id))
    ),
    [districtLevelCompetitions, submittedDistrictCompetitionIds]
  );
  const calendarCompetitions = useMemo(() => districtCompetitions.filter((competition) => competition.status !== 'cancelled' && /^\d{4}-\d{2}-\d{2}$/.test(competition.start_date || '')), [districtCompetitions]);
  const relevantAnnouncements = useMemo(() => announcements.filter((announcement) => {
    if (!announcement.is_active || (announcement.expires_at && new Date(announcement.expires_at) < new Date())) return false;
    if (announcement.scope === 'national') return true;
    if (announcement.scope === 'zone') return Number(announcement.zone) === Number(currentUser?.zone);
    if (announcement.scope === 'district') return Number(announcement.district) === visibleDistrictId;
    return Number(announcement.district) === visibleDistrictId || Number(announcement.region) === Number(allDistricts.find((district) => Number(district.id) === visibleDistrictId)?.region);
  }), [allDistricts, announcements, currentUser?.zone, visibleDistrictId]);
  const higherLevelAnnouncements = useMemo(() => relevantAnnouncements.filter((announcement) => ['national', 'zone', 'region'].includes(announcement.scope)), [relevantAnnouncements]);
  const lowerLevelAnnouncements = useMemo(() => relevantAnnouncements.filter((announcement) => announcement.scope === 'district' && Number(announcement.district) === visibleDistrictId), [relevantAnnouncements, visibleDistrictId]);
  const homeAnnouncements = useMemo(() => relevantAnnouncements.filter((announcement) => ['national', 'zone', 'region', 'district'].includes(announcement.scope)), [relevantAnnouncements]);
  const promotedTalentIds = useMemo(() => {
    const promotedDetailIds = new Set(promotions
      .filter((promotion) => promotion.to_level === 'district' && promotion.result_detail)
      .map((promotion) => Number(promotion.result_detail)));
    return new Set(resultDetails
      .filter((detail) => promotedDetailIds.has(Number(detail.id)))
      .map((detail) => Number(detail.talent)));
  }, [promotions, resultDetails]);
  const promotedDistrictTalents = useMemo(() => districtTalents.filter((entry) => promotedTalentIds.has(Number(entry.id))), [districtTalents, promotedTalentIds]);
  const pendingPromotionStudents = useMemo(() => {
    const schoolCompetitionIds = new Set(schoolCompetitions.map((competition) => Number(competition.id)));
    const studentMap = new Map(districtStudents.map((student) => [Number(student.id), student]));
    const schoolMap = new Map(districtSchools.map((school) => [Number(school.id), school]));
    const eligible = participations
      .filter((participation) => schoolCompetitionIds.has(Number(participation.competition)) && participation.status === 'finished' && Number(participation.score) >= 50)
      .map((participation) => {
        const student = studentMap.get(Number(participation.student));
        const schoolId = Number(student?.school?.id ?? student?.school);
        return { ...participation, studentRecord: student, schoolName: schoolMap.get(schoolId)?.name || 'School' };
      })
      .filter((participation) => participation.studentRecord);
    return Array.from(new Map(eligible.map((item) => [Number(item.student), item])).values());
  }, [districtSchools, districtStudents, participations, schoolCompetitions]);
  const navLinks = MENU_ITEMS.map((item) => ({
    ...item,
    active: activeMenu === item.key,
    onClick: () => setActiveMenu(item.key),
  }));

  const refreshData = () => window.location.reload();

  const talentParticipation = useMemo(() => {
    const counts = new Map();
    promotedDistrictTalents.forEach((entry) => {
      const talentName = entry.talent_name || 'Other talent';
      counts.set(talentName, (counts.get(talentName) || 0) + 1);
    });
    const total = promotedDistrictTalents.length;
    return [...counts.entries()]
      .sort(([, firstCount], [, secondCount]) => secondCount - firstCount)
      .map(([name, count]) => ({ name, count, percentage: total ? Math.round((count / total) * 100) : 0 }));
  }, [promotedDistrictTalents]);

  const talentChartColors = [
    '#0e1db6', '#4682b4', '#38a169', '#d69e2e',
    '#c05621', '#805ad5', '#319795', '#b83280',
    '#0891b2', '#65a30d', '#dc2626', '#7c3aed',
    '#ea580c', '#0369a1', '#be123c', '#4d7c0f',
  ];
  const talentChartTotal = talentParticipation.reduce((total, item) => total + item.count, 0);
  let talentChartOffset = 0;
  const talentChartSegments = talentParticipation.map((item, index) => {
    const percentage = talentChartTotal ? (item.count / talentChartTotal) * 100 : 0;
    const segment = { ...item, percentage, color: talentChartColors[index % talentChartColors.length], start: talentChartOffset };
    talentChartOffset += percentage;
    return segment;
  });
  const talentChartGradient = talentChartSegments.length
    ? `conic-gradient(${talentChartSegments.map((segment) => `${segment.color} ${segment.start}% ${segment.start + segment.percentage}%`).join(', ')})`
    : '#e5e7eb';

  const schoolRanking = useMemo(() => districtSchools.map((school) => {
    const schoolStudents = districtStudents.filter((student) => Number(student.school?.id ?? student.school) === Number(school.id));
    const schoolStudentIds = new Set(schoolStudents.map((student) => Number(student.id)));
    const schoolParticipations = participations.filter((participation) => schoolStudentIds.has(Number(participation.student)));
    const scored = schoolParticipations.filter((participation) => participation.score !== null && participation.score !== undefined);
    const averageScore = scored.length ? Math.round(scored.reduce((sum, item) => sum + Number(item.score), 0) / scored.length) : 0;
    return { name: school.name, students: schoolStudents.length, participation: schoolParticipations.length, averageScore };
  }).sort((first, second) => second.averageScore - first.averageScore || second.participation - first.participation).slice(0, 5), [districtSchools, districtStudents, participations]);

  const competitionDates = useMemo(() => {
    const dates = new Set();
    calendarCompetitions.forEach((competition) => {
      dates.add(competition.start_date);
    });
    return dates;
  }, [calendarCompetitions]);

  const calendarDays = useMemo(() => {
    const year = calendarDate.getFullYear();
    const month = calendarDate.getMonth();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    return { monthLabel: calendarDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' }), firstDay, daysInMonth, year, month };
  }, [calendarDate]);

  const calendarEvents = useMemo(() => calendarCompetitions
    .filter((competition) => {
      const start = new Date(`${competition.start_date}T00:00:00`);
      const end = competition.end_date ? new Date(`${competition.end_date}T00:00:00`) : start;
      return start.getFullYear() <= calendarDays.year && end.getFullYear() >= calendarDays.year
        && start <= new Date(calendarDays.year, calendarDays.month + 1, 0)
        && end >= new Date(calendarDays.year, calendarDays.month, 1);
    })
    .sort((first, second) => first.start_date.localeCompare(second.start_date)), [calendarDays, calendarCompetitions]);

  const moveCalendarMonth = (offset) => {
    setCalendarDate((current) => new Date(current.getFullYear(), current.getMonth() + offset, 1));
  };

  const goToCurrentMonth = () => setCalendarDate(new Date());

  const getCompetitionTooltip = (dateKey) => {
    const matches = calendarCompetitions.filter((competition) => {
      const start = competition.start_date;
      const end = competition.end_date || competition.start_date;
      return start === dateKey || end === dateKey;
    });

    if (!matches.length) return undefined;

    const [primaryMatch] = matches;
    return `${primaryMatch.name}\n${primaryMatch.level ? primaryMatch.level.charAt(0).toUpperCase() + primaryMatch.level.slice(1) : 'Competition'} level`;
  };

  const handleDeleteAnnouncement = async (announcementId) => {
    const announcement = announcements.find((item) => Number(item.id) === Number(announcementId));
    if (announcement?.scope !== 'district') return;
    try {
      await apiService.deleteAnnouncement(announcementId);
      setAnnouncements((items) => items.filter((item) => item.id !== announcementId));
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to delete announcement');
    }
  };

  const openProfileDrawer = () => {
    setProfileMenuOpen(false);
    setProfileEmail(currentUser?.email || '');
    setProfilePhone(currentUser?.phone || '');
    setProfileMessage(null);
    setProfileDrawerOpen(true);
  };

  const handleSaveProfile = async (event) => {
    event.preventDefault();
    const phone = profilePhone.trim();
    if (phone && !/^(?:0\d{9}|\+255\d{9})$/.test(phone)) {
      setProfileMessage({ type: 'error', text: 'Phone must be 10 digits starting with 0 or 13 characters starting with +255.' });
      return;
    }
    setProfileSubmitting(true);
    setProfileMessage(null);
    try {
      const response = await apiService.updateUserProfile(currentUser.id, { email: profileEmail.trim(), phone });
      setCurrentUser(response.data);
      setProfileDrawerOpen(false);
      setProfileMessage({ type: 'success', text: 'Profile updated successfully.' });
    } catch (err) {
      const responseErrors = err.response?.data;
      setProfileMessage({ type: 'error', text: responseErrors?.email?.[0] || responseErrors?.detail || 'Failed to update profile' });
    } finally {
      setProfileSubmitting(false);
    }
  };

  const openChangePasswordDrawer = () => {
    setProfileMenuOpen(false);
    setProfilePasswordForm({ new_password: '', confirm_password: '' });
    setShowProfilePassword(false);
    setShowProfilePasswordConfirmation(false);
    setPasswordDrawerOpen(true);
  };

  const handleChangePassword = async (event) => {
    event.preventDefault();
    if (profilePasswordForm.new_password !== profilePasswordForm.confirm_password) {
      setError('New passwords do not match.');
      return;
    }
    setProfileSubmitting(true);
    setError(null);
    try {
      await apiService.updateUserPassword(currentUser.id, profilePasswordForm.new_password);
      setProfilePasswordForm({ new_password: '', confirm_password: '' });
      setPasswordDrawerOpen(false);
    } catch (err) {
      const responseErrors = err.response?.data;
      setError(responseErrors?.detail || responseErrors?.password?.[0] || 'Failed to change password');
    } finally {
      setProfileSubmitting(false);
    }
  };

  const openCompetitionEditor = (competition = null) => {
    setSelectedCompetition(competition);
    setCompetitionForm({
      name: competition?.name || '',
      description: competition?.description || '',
      venue: competition?.venue || '',
      start_date: competition?.start_date || '',
      end_date: competition?.end_date || '',
      talent: competition?.talent != null
        ? String(typeof competition.talent === 'object' ? competition.talent.id : competition.talent)
        : '',
    });
    setCompetitionDrawerOpen(true);
  };

  const closeCompetitionEditor = () => {
    setCompetitionDrawerOpen(false);
    setSelectedCompetition(null);
    setCompetitionForm({ name: '', description: '', venue: '', start_date: '', end_date: '', talent: '' });
  };

  const handleSaveCompetition = async (event) => {
    event.preventDefault();
    setCompetitionSubmitting(true);
    setError(null);
    try {
      const payload = {
        name: competitionForm.name.trim(),
        description: competitionForm.description.trim(),
        venue: competitionForm.venue.trim(),
        start_date: competitionForm.start_date,
        end_date: competitionForm.end_date || null,
        talent: competitionForm.talent ? Number(competitionForm.talent) : null,
        level: 'district',
      };
      if (selectedCompetition) {
        await apiService.patchCompetition(selectedCompetition.id, payload);
      } else {
        await apiService.createCompetition({ ...payload, schools: [] });
      }
      closeCompetitionEditor();
      const competitionsRes = await apiService.getCompetitions();
      setCompetitions(competitionsRes.data.results || []);
    } catch (err) {
      setError(err.response?.data?.detail || err.response?.data?.non_field_errors?.[0] || 'Failed to save competition');
    } finally {
      setCompetitionSubmitting(false);
    }
  };

  const handleDeleteCompetition = async () => {
    if (!selectedCompetition || !window.confirm('Delete this competition?')) return;
    setCompetitionSubmitting(true);
    setError(null);
    try {
      await apiService.deleteCompetition(selectedCompetition.id);
      closeCompetitionEditor();
      setCompetitions((items) => items.filter((item) => item.id !== selectedCompetition.id));
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to delete competition');
    } finally {
      setCompetitionSubmitting(false);
    }
  };

  const handleAutoSelectTopStudents = (entries) => {
    const requested = Number.parseInt(promotionStudentLimit, 10);
    const target = availablePromotionDistrictCompetitions.find(
      (c) => Number(c.id) === Number(selectedDistrictCompetitionId)
    );

    if (!target) {
      setError('Select a district competition first.');
      return;
    }
    if (!Number.isInteger(requested) || requested < 1) {
      setError('Enter a valid number of students to promote.');
      return;
    }

    const score = (e) =>
      Number(e.detail?.percentage_score ?? e.detail?.raw_score ?? 0);
    const studentId = (e) =>
      Number(e.student?.id ?? e.student_id ?? e.studentId ?? 0);

    // Use only eligible, unpromoted results scoring at least 50%.
    const best = new Map();
    entries.filter((e) =>
      e.detail?.id &&
      !e.isPromoted &&
      e.isEligibleForPromotion &&
      score(e) >= 50
    ).forEach((e) => {
      const key = studentId(e) || `detail-${e.detail.id}`;
      const old = best.get(key);
      if (
        !old ||
        score(e) > score(old) ||
        (score(e) === score(old) &&
          Number(e.detail.id) < Number(old.detail.id))
      ) best.set(key, e);
    });

    const eligible = [...best.values()];
    if (!eligible.length) {
      setSelectedPromotionStudents([]);
      setError('No eligible students scoring 50% or above are available.');
      return;
    }

    const schools = new Map();
    eligible.forEach((e) => {
      const key = e.school?.id ?? e.school?.name ?? 'unknown';
      if (!schools.has(key)) schools.set(key, []);
      schools.get(key).push(e);
    });

    const compare = (a, b) =>
      score(b) - score(a) ||
      Number(a.school?.id ?? 0) - Number(b.school?.id ?? 0) ||
      studentId(a) - studentId(b) ||
      Number(a.detail.id) - Number(b.detail.id);

    const groups = [...schools.entries()]
      .map(([key, candidates]) => ({
        key,
        candidates: candidates.sort(compare),
      }))
      .sort((a, b) => {
        const aId = Number(a.key);
        const bId = Number(b.key);

        if (Number.isFinite(aId) && Number.isFinite(bId)) {
          return aId - bId;
        }

        return String(a.key).localeCompare(String(b.key));
      });

    const base = Math.floor(requested / groups.length);
    const extra = requested % groups.length;
    const chosen = [];
    const chosenIds = new Set();

    groups.forEach((group, index) => {
      group.candidates.slice(0, base + (index < extra ? 1 : 0))
        .forEach((e) => {
          const id = Number(e.detail.id);
          if (!chosenIds.has(id)) {
            chosen.push(e);
            chosenIds.add(id);
          }
        });
    });

    // Reallocate unused school quotas by highest score.
    const remaining = eligible
      .filter((e) => !chosenIds.has(Number(e.detail.id)))
      .sort(compare);

    for (const e of remaining) {
      if (chosen.length >= requested) break;
      chosen.push(e);
      chosenIds.add(Number(e.detail.id));
    }

    // Store IDs, not objects, so the UI and API use the same data type.
    setSelectedPromotionStudents(chosen.map((e) => Number(e.detail.id)));
    setError(
      chosen.length < requested
        ? `Only ${chosen.length} eligible students are available out of ${requested} requested.`
        : null
    );
  };

  const handlePromoteStudents = async (
    sourceCompetitionIds,
    detailIds = selectedPromotionStudents
  ) => {
    const target = availablePromotionDistrictCompetitions.find(
      (c) => Number(c.id) === Number(selectedDistrictCompetitionId)
    );
    const sourceIds = [
      ...new Set(
        (Array.isArray(sourceCompetitionIds)
          ? sourceCompetitionIds
          : [sourceCompetitionIds]
        ).map(Number).filter((id) => Number.isFinite(id) && id > 0)
      ),
    ];
    const selectedIds = [
      ...new Set(
        (Array.isArray(detailIds) ? detailIds : [])
          .map(Number).filter((id) => Number.isFinite(id) && id > 0)
      ),
    ];
    const requested = Number.parseInt(promotionStudentLimit, 10);

    if (!target) {
      setError('Select a district competition before promoting students.');
      return;
    }
    if (!sourceIds.length) {
      setError('No submitted school competitions are available.');
      return;
    }
    if (!selectedIds.length) {
      setError('Click Search Top Students before promoting students.');
      return;
    }
    if (!Number.isInteger(requested) || requested < 1) {
      setError('Enter a valid number of students to promote.');
      return;
    }

    setSubmittingSchoolCompetitionId(-1);
    setError(null);

    try {
      const response = await apiService.promoteStudents({
        competition_id: sourceIds[0],
        competition_ids: sourceIds,
        result_detail_ids: selectedIds,
        district_competition_id: target.id,
        total_students: requested,
        from_level: 'school',
        to_level: 'district',
      });

      const data = response.data || {};
      const count = Number(data.promoted || 0);
      const errors = Array.isArray(data.errors) ? data.errors : [];

      if (count < 1) {
        setError(errors.join(' ') || 'No eligible students were promoted.');
        return;
      }

      const [resultsRes, participationsRes, promotionsRes] =
        await Promise.all([
          apiService.getAllResults(),
          apiService.getAllParticipations(),
          apiService.getAllResultPromotions(),
        ]);

      setResults(resultsRes.data.results || []);
      setParticipations(participationsRes.data.results || []);
      setPromotions(promotionsRes.data.results || []);
      setSelectedPromotionStudents([]);
      showSuccess(`Successfully promoted ${count} student(s) to district level.`);
      if (errors.length) setError(errors.join(' '));
    } catch (err) {
      setError(
        err.response?.data?.error ||
        err.response?.data?.detail ||
        'Failed to promote students'
      );
    } finally {
      setSubmittingSchoolCompetitionId(null);
    }
  };

  const handleSubmitDistrictResults = async (sourceCompetitionId, detailIds = []) => {
    if (!sourceCompetitionId) {
      setError('Select a district competition to submit.');
      return;
    }
    setSubmittingDistrictCompetitionId(Number(sourceCompetitionId));
    try {
      const existingSubmission = districtSubmissions.find((submission) => Number(submission.competition) === Number(sourceCompetitionId));
      const submission = existingSubmission || (await apiService.createDistrictResultSubmission({ competition: sourceCompetitionId })).data;
      const submittedSubmission = await apiService.submitDistrictResultSubmission(submission.id);
      setSelectedPromotionStudents([]);
      setSelectedDemotionDetails([]);
      setDistrictSubmissions((current) => [
        ...current.filter((item) => Number(item.competition) !== Number(sourceCompetitionId)),
        submittedSubmission.data,
      ]);
      const [resultsRes, participationsRes, promotionsRes] = await Promise.all([apiService.getAllResults(), apiService.getAllParticipations(), apiService.getAllResultPromotions()]);
      setResults(resultsRes.data.results || []);
      setParticipations(participationsRes.data.results || []);
      setPromotions(promotionsRes.data.results || []);
      showSuccess('District results submitted to zone successfully.');
    } catch (err) {
      setError(err.response?.data?.error || err.response?.data?.detail || 'Failed to submit district results');
    } finally {
      setSubmittingDistrictCompetitionId(null);
    }
  };

  const handleSaveDistrictScore = async (resultId, detailId, score) => {
    const isLocked = detailId
      ? promotions.some((promotion) => ['district', 'zone', 'country'].includes(promotion.to_level) && Number(promotion.result_detail) === Number(detailId))
      : promotions.some((promotion) => ['district', 'zone', 'country'].includes(promotion.to_level) && Number(promotion.result) === Number(resultId));

    if (isLocked) return;

    try {
      if (detailId) {
        await apiService.updateResultDetail(detailId, {
          raw_score: score === '' ? 0 : Number(score),
          percentage_score: score === '' ? null : Number(score),
        });
      } else {
        await apiService.updateResult(resultId, { score: score === '' ? null : Number(score) });
      }
      const resultsRes = await apiService.getResults();
      setResults(resultsRes.data.results || []);
    } catch (err) {
      setError(err.response?.data?.detail || err.response?.data?.score?.[0] || 'Failed to save district result');
    }
  };

  const handleDemoteTalents = async (detailIds = selectedDemotionDetails) => {
    if (!detailIds.length) {
      setError('Select at least one district result to de-promote.');
      return;
    }
    if (!window.confirm(`Remove ${detailIds.length} selected result${detailIds.length === 1 ? '' : 's'} from district level?`)) return;
    try {
      await apiService.demoteResultTalent({ result_detail_ids: detailIds });
      const [resultsRes, promotionsRes, resultDetailsRes] = await Promise.all([apiService.getResults(), apiService.getAllResultPromotions(), apiService.getAllResultDetails()]);
      setResults(resultsRes.data.results || []);
      setPromotions(promotionsRes.data.results || []);
      setResultDetails(resultDetailsRes.data.results || []);
      setSelectedDemotionDetails([]);
    } catch (err) {
      setError(err.response?.data?.detail || err.response?.data?.error || 'Failed to remove district promotion');
    }
  };

  const handleReopenSchoolSubmission = async (submissionId) => {
    try {
      const response = await apiService.reopenSchoolResultSubmission(submissionId);
      setSchoolSubmissions((items) => items.map((item) => item.id === submissionId ? response.data : item));
      const [resultsRes, participationsRes, promotionsRes, resultDetailsRes] = await Promise.all([
        apiService.getAllResults(),
        apiService.getAllParticipations(),
        apiService.getAllResultPromotions(),
        apiService.getAllResultDetails(),
      ]);
      setResults(resultsRes.data.results || []);
      setParticipations(participationsRes.data.results || []);
      setPromotions(promotionsRes.data.results || []);
      setResultDetails(resultDetailsRes.data.results || []);
      showSuccess(`School results returned to draft. ${response.data.demoted || 0} district promotion(s) were reversed.`);
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to reopen school results');
    }
  };

  const getStudentClassName = (student) => {
    const educationLevelId = student?.education_level?.id ?? student?.education_level;
    return educationLevels.find((level) => Number(level.id) === Number(educationLevelId))?.name || '—';
  };

  const handleCreateAnnouncement = async (event) => {
    event.preventDefault();
    setAnnouncementSubmitting(true);
    try {
      const announcementData = {
        title: announcementForm.title.trim(),
        content: announcementForm.content.trim(),
        audience: announcementForm.audience,
        scope: 'district',
        district: visibleDistrictId,
        published_at: announcementForm.published_at || null,
        expires_at: announcementForm.expires_at || null,
        is_active: true,
      };
      if (selectedAnnouncement) {
        await apiService.updateAnnouncement(selectedAnnouncement.id, announcementData);
      } else {
        await apiService.createAnnouncement(announcementData);
      }
      setAnnouncementForm({ title: '', content: '', expires_at: '', audience: 'both' });
      setSelectedAnnouncement(null);
      setAnnouncementDrawerOpen(false);
      const announcementsRes = await apiService.getAnnouncements({ is_active: true });
      setAnnouncements(announcementsRes.data.results || []);
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to create announcement');
    } finally {
      setAnnouncementSubmitting(false);
    }
  };

  const openAnnouncementEditor = (announcement = null) => {
    if (announcement && announcement.scope !== 'district') return;
    setSelectedAnnouncement(announcement);
    setAnnouncementForm({
      title: announcement?.title || '',
      content: announcement?.content || '',
      published_at: announcement?.published_at ? announcement.published_at.slice(0, 16) : '',
      expires_at: announcement?.expires_at ? announcement.expires_at.slice(0, 16) : '',
      audience: announcement?.audience || 'both',
    });
    setAnnouncementDrawerOpen(true);
  };

  const handleDeleteDistrictAnnouncement = async () => {
    if (!selectedAnnouncement || selectedAnnouncement.scope !== 'district' || !window.confirm('Delete this announcement?')) return;
    setAnnouncementSubmitting(true);
    try {
      await apiService.deleteAnnouncement(selectedAnnouncement.id);
      setAnnouncements((items) => items.filter((item) => item.id !== selectedAnnouncement.id));
      setSelectedAnnouncement(null);
      setAnnouncementDrawerOpen(false);
      setAnnouncementForm({ title: '', content: '', expires_at: '', audience: 'both' });
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to delete announcement');
    } finally {
      setAnnouncementSubmitting(false);
    }
  };

  const renderHomeView = () => (
    <>
      <div className="district-home-grid row g-4">
        <section className="district-home-card talent-card col-12 col-xl-6">
          <div className="district-card-heading"><div><h2>Talent participation</h2><p>Talents promoted to district level</p></div><span className="district-card-kicker">{promotedDistrictTalents.length} promoted</span></div>
          {talentChartSegments.length ? (
            <div className="sport-teacher-talent-donut-layout">
              <div className="sport-teacher-talent-donut" style={{ background: talentChartGradient }} aria-label="District talent participation donut chart">
                <div><strong>{talentChartTotal}</strong><span>promoted</span></div>
              </div>
              <div className="sport-teacher-talent-donut-legend">
                {talentChartSegments.map((segment) => (
                  <div className="sport-teacher-talent-legend-item" key={segment.name}>
                    <span className="sport-teacher-talent-legend-name"><i style={{ background: segment.color }} />{segment.name}</span>
                    <strong>{segment.count}</strong>
                  </div>
                ))}
              </div>
            </div>
          ) : <p className="district-empty-state">No promoted talents yet.</p>}
        </section>

        <section className="district-home-card col-12 col-xl-6">
          <div className="district-card-heading"><div><h2>Recent announcements</h2><p>Publish or remove district updates</p></div><button type="button" className="district-text-button" onClick={() => setActiveMenu('announcements')}>View all</button></div>
          <div className="recent-announcements">{homeAnnouncements.slice(0, 3).map((announcement) => <div className="recent-announcement-row" key={announcement.id}><div><strong>{announcement.title}</strong><small>{announcement.content || 'No details available.'}</small></div></div>)}{!homeAnnouncements.length && <p className="district-empty-state">No active announcements yet.</p>}</div>
        </section>

        <section className="district-home-card col-12 col-xl-6">
          <div className="district-card-heading"><div><h2>Competition management</h2><p>Create and manage Sengerema district events</p></div><button type="button" className="district-primary-button district-card-action" onClick={() => openCompetitionEditor()}>Add competition</button></div>
          <div className="district-competition-list">
            {districtLevelCompetitions.map((competition) => (
              <button type="button" className="district-competition-row is-editable" key={competition.id} onClick={() => openCompetitionEditor(competition)} aria-label={`Edit ${competition.name}`}>
                <strong className="district-competition-title">{competition.name}</strong>
                <span>{competition.start_date || 'Date not set'}{competition.end_date ? ` - ${competition.end_date}` : ''}</span>
              </button>
            ))}
            {!districtLevelCompetitions.length && <p className="district-empty-state">No district competitions created yet.</p>}
          </div>
        </section>

        <section className="district-home-card col-12 col-xl-6">
          <div className="district-card-heading"><div><h2>School performance</h2><p>Ranked by average recorded score</p></div><span className="district-card-kicker">Top 5</span></div>
          <div className="school-ranking">{schoolRanking.length ? schoolRanking.map((school, index) => <div className="school-ranking-row" key={school.name}><span className="school-rank">{index + 1}</span><div className="school-ranking-name"><strong>{school.name}</strong><small>{school.students} students · {school.participation} entries</small></div><b>{school.averageScore}%</b></div>) : <p className="district-empty-state">No school performance data yet.</p>}</div>
        </section>

        <section className="district-home-card district-calendar-card col-12 col-xl-6">
          <div className="district-card-heading"><div><h2>Competition calendar</h2><p>Blue circles mark competition days</p></div><div className="calendar-controls"><button type="button" onClick={() => moveCalendarMonth(-1)} aria-label="Previous month" title="Previous month">‹</button><span>{calendarDays.monthLabel}</span><button type="button" onClick={() => moveCalendarMonth(1)} aria-label="Next month" title="Next month">›</button><button type="button" className="calendar-today-button" onClick={goToCurrentMonth}>Today</button></div></div>
          <div className="calendar-weekdays">{['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => <span key={day}>{day}</span>)}</div>
          <div className="calendar-grid">{Array.from({ length: calendarDays.firstDay }).map((_, index) => <span className="calendar-day is-empty" key={`empty-${index}`} />)}{Array.from({ length: calendarDays.daysInMonth }, (_, index) => { const day = index + 1; const dateKey = `${calendarDays.year}-${String(calendarDays.month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`; const isToday = new Date().toISOString().slice(0, 10) === dateKey; const tooltip = getCompetitionTooltip(dateKey); return <span className={`calendar-day ${competitionDates.has(dateKey) ? 'has-competition' : ''} ${isToday ? 'is-today' : ''}`} key={dateKey} title={tooltip || undefined}>{day}</span>; })}</div>
          <div className="calendar-events">{calendarEvents.length ? calendarEvents.map((competition) => <div key={competition.id}><span className="calendar-event-dot" /> <strong>{competition.name}</strong><small>{competition.start_date}{competition.end_date ? ` - ${competition.end_date}` : ''}</small></div>) : <p className="district-empty-state">No competitions this month.</p>}</div>
        </section>
      </div>
    </>
  );

  const renderResultsView = () => {
    const submittedSchoolCompetitions = schoolCompetitions
      .filter((competition) => schoolSubmissions.some((submission) => Number(submission.competition) === Number(competition.id) && submission.status === 'submitted'))
      .map((competition) => {
        const entries = participations
          .filter((participation) => Number(participation.competition) === Number(competition.id) && districtStudents.some((student) => Number(student.id) === Number(participation.student)))
          .flatMap((participation) => {
            const result = results.find((item) => Number(item.participation) === Number(participation.id));
            const student = districtStudents.find((item) => Number(item.id) === Number(participation.student));
            const school = districtSchools.find((item) => Number(item.id) === Number(student?.school?.id ?? student?.school));
            const details = result?.details || [];
            const promotedDetailIds = new Set(promotions.filter((promotion) => promotion.to_level === 'district' && promotion.result_detail).map((promotion) => Number(promotion.result_detail)));
            return details.map((detail) => {
              const isPromoted =
                promotedDetailIds.has(Number(detail.id)) ||
                detail.promotion_status === 'promoted' ||
                detail.promoted_to === 'district';
              const isProcessed =
                isPromoted || detail.promotion_status === 'not_promoted';

              return {
                participation,
                result,
                detail,
                student,
                school,
                isPromoted,
                isProcessed,
                isEligibleForPromotion:
                  !isProcessed &&
                  Number(detail.percentage_score ?? detail.raw_score ?? 0) >= 50,
              };
            });
          });
        return { ...competition, entries };
      });

    const visibleSchoolCompetitions = submittedSchoolCompetitions
      .map((competition) => ({
        ...competition,
        entries: competition.entries.filter(
          (entry) =>
            !entry.isProcessed &&
            Number(entry.detail?.percentage_score ?? entry.detail?.raw_score ?? 0) >= 50
        ),
      }))
      .filter((competition) => competition.entries.length > 0);

    // All unprocessed submitted school results scoring 50% or higher
    // count as eligible, regardless of which talent is being promoted.
    const districtWidePromotionCandidates = visibleSchoolCompetitions.flatMap(
      (competition) => competition.entries.filter((entry) =>
        entry.detail?.id &&
        !entry.isPromoted &&
        entry.isEligibleForPromotion &&
        Number(entry.detail?.percentage_score ?? entry.detail?.raw_score ?? 0) >= 50
      )
    );

    const districtWideEligibleStudentCount = new Set(
      districtWidePromotionCandidates.map((entry) =>
        Number(entry.student?.id ?? entry.student_id ?? entry.studentId ?? 0)
      ).filter((id) => id > 0)
    ).size;

    const processedSchoolCompetitions = submittedSchoolCompetitions
      .map((competition) => ({
        ...competition,
        entries: competition.entries
          .filter(
            (entry) =>
              entry.isProcessed &&
              Number(entry.detail?.percentage_score ?? entry.detail?.raw_score ?? 0) >= 50
          )
          .sort(
            (a, b) =>
              Number(b.detail.percentage_score ?? b.detail.raw_score ?? 0) -
              Number(a.detail.percentage_score ?? a.detail.raw_score ?? 0),
          ),
      }))
      .filter((competition) => competition.entries.length > 0);

    if (activeMenu === 'promoted-school-results') {
      return (
        <div className="district-results-stack">
          <div className="district-results-heading">
            <div>
              <h2>SchoolResults</h2>
              <p>All school results reviewed for promotion, grouped by their original competition and ranked by score.</p>
            </div>
          </div>
          {processedSchoolCompetitions.map((competition) => (
            <section className="district-result-card" key={competition.id}>
              <div className="district-result-card-header">
                <div>
                  <h3>{competition.name}</h3>
                  <p>Original school scores are preserved. Only results scoring 50% or above are listed here.</p>
                </div>
              </div>
              <div className="district-result-table-wrap">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Rank</th><th>Student</th><th>Username</th><th>Talent</th>
                      <th>Class</th><th>School</th><th>Score</th>
                      <th>Grade</th><th>Status</th><th>Award</th><th>Remark</th>
                    </tr>
                  </thead>
                  <tbody>
                    {competition.entries.map(({ participation, detail, student, school, isPromoted }, index) => (
                      <tr key={`${participation.id}-${detail.id}`}>
                        <td>{index + 1}</td>
                        <td>{student ? `${student.first_name} ${student.last_name}` : 'Student'}</td>
                        <td>{detail.student_username || student?.student_id || '—'}</td>
                        <td>{detail.talent_name || '—'}</td>
                        <td>{getStudentClassName(student)}</td>
                        <td>{school?.name || 'School'}</td>
                        <td>{detail.percentage_score ?? 'Not recorded'}</td>
                        <td>
                          {detail.percentage_score == null ? 'Not recorded'
                            : detail.percentage_score >= 90 ? 'A+'
                            : detail.percentage_score >= 75 ? 'A'
                            : detail.percentage_score >= 60 ? 'B+'
                            : detail.percentage_score >= 50 ? 'B'
                            : detail.percentage_score >= 40 ? 'C'
                            : detail.percentage_score >= 30 ? 'D'
                            : detail.percentage_score >= 20 ? 'E' : 'F'}
                        </td>
                        <td>
                          {(() => {
                            const status = Number(detail.percentage_score ?? detail.raw_score) < 50
                              ? 'Fail'
                              : isPromoted ? 'Promoted' : 'Not Promoted';
                            const statusClass = status === 'Promoted'
                              ? 'is-promoted'
                              : status === 'Fail' ? 'is-fail' : 'is-not-promoted';
                            return <span className={`district-status-badge ${statusClass}`}>{status}</span>;
                          })()}
                        </td>
                        <td>
                          {(() => {
                            const awarded = String(detail.award_status || 'none').toLowerCase() === 'awarded';
                            return <span className={`district-status-badge ${awarded ? 'is-awarded' : 'is-none'}`}>
                              {awarded ? 'Awarded' : 'None'}
                            </span>;
                          })()}
                        </td>
                        <td>{detail.remark || '—'}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </section>
          ))}
          {!processedSchoolCompetitions.length && (
            <section className="district-result-card">
              <p className="district-result-empty">No school results have been processed for promotion yet.</p>
            </section>
          )}
        </div>
      );
    }

    if (activeMenu === 'school-results') {
      return (
        <div className="district-results-stack">
          <div className="district-results-heading">
            <div>
              <h2>School-level results</h2>
              <p>Review submitted results from schools in your district.</p>
            </div>
          </div>
          <section className="district-result-card">
            <div className="district-result-card-header">
              <div>
                <h3>District-wide promotion</h3>
                <p>Only students scoring 50% or higher are eligible. Places are shared across schools, with unused places allocated to the highest-scoring remaining students.</p>
              </div>
              <div className="district-result-header-actions">
                <label style={{ display: 'flex', flexDirection: 'column', gap: '4px', fontSize: '12px' }}>
                  Number of students
                  <input
                    type="number"
                    min="1"
                    step="1"
                    value={promotionStudentLimit}
                    onChange={(event) => {
                      setPromotionStudentLimit(event.target.value);
                      setSelectedPromotionStudents([]);
                    }}
                    disabled={submittingSchoolCompetitionId !== null}
                    style={{ width: '140px', height: '36px', boxSizing: 'border-box' }}
                  />
                </label>
                <label className="district-promotion-competition-field">
                  Promote to
                  <select
                    value={selectedDistrictCompetitionId}
                    onChange={(event) => {
                      setSelectedDistrictCompetitionId(event.target.value);
                      setSelectedPromotionStudents([]);
                      setError(null);
                    }}
                    disabled={submittingSchoolCompetitionId !== null}
                  >
                    <option value="">Select district competition</option>
                    {availablePromotionDistrictCompetitions.map((item) => (
                      <option key={item.id} value={item.id}>{item.name}</option>
                    ))}
                  </select>
                </label>
                <button
                  type="button"
                  className="btn-primary"
                  onClick={() => handleAutoSelectTopStudents(districtWidePromotionCandidates)}
                  disabled={submittingSchoolCompetitionId !== null || !selectedDistrictCompetitionId || !districtWidePromotionCandidates.length}
                  style={{ height: '36px', padding: '8px 12px', border: '1px solid #e5e7eb', borderRadius: '6px', background: '#0E1DB6', color: 'white', fontSize: '13px', cursor: 'pointer' }}
                >
                  Search Top Students
                </button>
                <button
                  type="button"
                  className="btn-primary"
                  onClick={() => handlePromoteStudents(
                    visibleSchoolCompetitions.map((competition) => competition.id),
                    selectedPromotionStudents
                  )}
                  disabled={submittingSchoolCompetitionId !== null || !selectedDistrictCompetitionId || !selectedPromotionStudents.length}
                  style={{ width: '140px', height: '36px', boxSizing: 'border-box', padding: '8px 16px', border: '1px solid #e5e7eb', borderRadius: '6px', background: '#0E1DB6', color: 'white', fontSize: '14px', cursor: 'pointer' }}
                >
                  {submittingSchoolCompetitionId !== null ? 'Promoting...' : 'Promote'}
                </button>
              </div>
            </div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '24px', padding: '12px 0' }}>
              <div><strong style={{ display: 'block', fontSize: '12px', color: '#6b7280' }}>Total Schools</strong><span style={{ fontSize: '24px', fontWeight: 700 }}>{districtSchools.length}</span></div>
              <div><strong style={{ display: 'block', fontSize: '12px', color: '#6b7280' }}>Eligible Students (50%+)</strong><span style={{ fontSize: '24px', fontWeight: 700 }}>{districtWideEligibleStudentCount}</span></div>
              <div><strong style={{ display: 'block', fontSize: '12px', color: '#6b7280' }}>Selected for Promotion</strong><span style={{ fontSize: '24px', fontWeight: 700 }}>{selectedPromotionStudents.length}</span></div>
            </div>
          </section>
          {visibleSchoolCompetitions.map((competition) => (
              <section className="district-result-card" key={competition.id}>
                <div className="district-result-card-header">
                  <div><h3>{competition.name}</h3><p>Submitted school-level results. Only scores of 50% or higher are shown.</p></div>
                <div className="district-result-header-actions">
                  {schoolSubmissions.find(
                    (submission) => Number(submission.competition) === Number(competition.id)
                  )?.status === 'submitted' && (
                    <button
                      type="button"
                      className="district-text-button"
                      onClick={() => handleReopenSchoolSubmission(
                        schoolSubmissions.find(
                          (submission) => Number(submission.competition) === Number(competition.id)
                        ).id
                      )}
                      style={{ width: '140px', height: '36px', boxSizing: 'border-box', padding: '8px 16px', border: '1px solid #e5e7eb', borderRadius: '6px', background: '#d1d5db', fontSize: '14px', cursor: 'pointer' }}
                    >
                      Set draft
                    </button>
                  )}
                </div>
              </div>
              <div className="district-result-table-wrap">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Select</th><th>Student</th><th>Username</th><th>Talent</th>
                      <th>Class</th><th>School</th><th>Club</th><th>Score</th>
                      <th>Grade</th><th>Status</th><th>Award</th><th>Remark</th>
                    </tr>
                  </thead>
                  <tbody>
                    {competition.entries.map(({ participation, detail, student, school, isPromoted, isEligibleForPromotion }) => (
                      <tr key={`${participation.id}-${detail.id}`}>
                        <td>
                          {isPromoted
                            ? <span className="district-promoted-label">Promoted</span>
                            : <input
                                type="checkbox"
                                checked={isEligibleForPromotion && selectedPromotionStudents.includes(Number(detail.id))}
                                disabled
                                onChange={(event) => setSelectedPromotionStudents((current) => event.target.checked
                                  ? [...new Set([...current, Number(detail.id)])]
                                  : current.filter((id) => id !== Number(detail.id)))}
                                aria-label={`Select ${student?.first_name || 'student'} ${detail.talent_name || 'talent'} for promotion`}
                              />
                          }
                        </td>
                        <td>{student ? `${student.first_name} ${student.last_name}` : 'Student'}</td>
                        <td>{detail.student_username || student?.student_id || '—'}</td>
                        <td>{detail.talent_name || '—'}</td>
                        <td>{getStudentClassName(student)}</td>
                        <td>{school?.name || 'School'}</td>
                        <td>{clubMemberships.find((membership) => Number(membership.student) === Number(student?.id) && membership.is_active)?.club_name || '—'}</td>
                        <td>{detail.percentage_score ?? 'Not recorded'}</td>
                        <td>
                          {detail.percentage_score == null ? 'Not recorded'
                            : detail.percentage_score >= 90 ? 'A+'
                            : detail.percentage_score >= 75 ? 'A'
                            : detail.percentage_score >= 60 ? 'B+'
                            : detail.percentage_score >= 50 ? 'B'
                            : detail.percentage_score >= 40 ? 'C'
                            : detail.percentage_score >= 30 ? 'D'
                            : detail.percentage_score >= 20 ? 'E' : 'F'}
                        </td>
                        <td>
                          {(() => {
                            const status = String(detail.status || 'pending');
                            const normalized = status.toLowerCase();
                            const statusClass = normalized.includes('fail')
                              ? 'is-fail'
                              : normalized.includes('promoted')
                                ? (normalized.includes('not promoted') ? 'is-not-promoted' : 'is-promoted')
                                : 'is-pending';
                            return <span className={`district-status-badge ${statusClass}`}>{status}</span>;
                          })()}
                        </td>
                        <td>
                          {(() => {
                            const awarded = String(detail.award_status || 'none').toLowerCase() === 'awarded';
                            return <span className={`district-status-badge ${awarded ? 'is-awarded' : 'is-none'}`}>
                              {awarded ? 'Awarded' : 'None'}
                            </span>;
                          })()}
                        </td>
                        <td>{detail.remark || '—'}</td>
                      </tr>
                    ))}
                    {!competition.entries.length && (
                      <tr><td colSpan="12" className="district-result-empty">No submitted results available yet.</td></tr>
                    )}
                  </tbody>
                </table>
              </div>
            </section>
          ))}
          {!visibleSchoolCompetitions.length && <section className="district-result-card"><p className="district-result-empty">No unpromoted school results are available.</p></section>}
        </div>
      );
    }    const districtResultsByCompetition = districtLevelCompetitions.map((competition) => {
      const zonePromotedDetailIds = new Set(
        promotions
          .filter((promotion) => promotion.to_level === 'zone' && promotion.result_detail)
          .map((promotion) => Number(promotion.result_detail)),
      );

      const entries = results.filter((result) => {
        const participation = participations.find((item) => Number(item.id) === Number(result.participation));
        return Number(participation?.competition) === Number(competition.id);
      }).flatMap((result) => {
        const participation = participations.find((item) => Number(item.id) === Number(result.participation));
        const participationStudentId = participation?.student?.id ?? participation?.student;
        const student = students.find((item) => Number(item.id) === Number(participationStudentId));
        const details = result.details || [];

        return details.length
          ? details.map((detail) => ({
              ...result,
              detail,
              student,
              isZonePromoted: zonePromotedDetailIds.has(Number(detail.id)) || detail.promoted_to === 'zone',
            }))
          : [{ ...result, detail: null, student, isZonePromoted: false }];
      });

      return { ...competition, entries };
    });

    const submittedDistrictResults = districtResultsByCompetition.filter((competition) =>
      districtSubmissions.some((submission) =>
        Number(submission.competition) === Number(competition.id) &&
        submission.status === 'submitted'
      )
    );

    if (activeMenu === 'district-archive-results') {
      return (
        <div className="district-results-stack">
          <div className="district-results-heading">
            <div>
              <h2>DistrictResults</h2>
              <p>Archived district results submitted to the zone.</p>
            </div>
          </div>
          {submittedDistrictResults.map((competition) => {
            const passingEntries = competition.entries.filter((result) => {
              const score = result.detail?.percentage_score ?? result.detail?.raw_score;
              return score != null && Number(score) >= 50;
            });
            return (
            <section className="district-result-card" key={`district-archive-${competition.id}`}>
              <div className="district-result-card-header">
                <div>
                  <h3>{competition.name}</h3>
                  <p>Submitted to zone · {competition.entries.length} result entries</p>
                </div>
              </div>
              <div className="district-result-table-wrap">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Student</th><th>Talent</th><th>School</th>
                      <th>Score</th><th>Grade</th><th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {passingEntries.map((result) => {
                      const score = result.detail?.percentage_score ?? result.detail?.raw_score;
                      const resultStatus = score == null
                        ? 'Pending'
                        : Number(score) < 50
                          ? 'Fail'
                          : result.isZonePromoted
                            || result.detail?.promoted_to === 'zone'
                            || result.detail?.promotion_status === 'promoted'
                            ? 'Promoted'
                            : 'Pending';
                      const numericScore = score == null ? null : Number(score);
                      const grade = numericScore == null ? 'Not recorded'
                        : numericScore >= 90 ? 'A+'
                        : numericScore >= 75 ? 'A'
                        : numericScore >= 60 ? 'B+'
                        : numericScore >= 50 ? 'B'
                        : numericScore >= 40 ? 'C'
                        : numericScore >= 30 ? 'D'
                        : numericScore >= 20 ? 'E' : 'F';

                      return (
                        <tr key={`${result.id}-${result.detail?.id || 'overall'}`}>
                          <td>{result.student
                            ? `${result.student.first_name} ${result.student.last_name}`
                            : 'Student'}</td>
                          <td>{result.detail?.talent_name || 'Overall result'}</td>
                          <td>{districtSchools.find((school) =>
                            Number(school.id) === Number(
                              result.student?.school?.id ?? result.student?.school
                            )
                          )?.name || 'School'}</td>
                          <td>{score ?? 'Not recorded'}</td>
                          <td>{grade}</td>
                          <td>
                            <span className={`district-status-badge ${
                              resultStatus === 'Promoted' ? 'is-promoted'
                                : resultStatus === 'Not Promoted' ? 'is-not-promoted'
                                : resultStatus === 'Fail' ? 'is-fail' : 'is-pending'
                            }`}>{resultStatus}</span>
                          </td>
                        </tr>
                      );
                    })}
                    {!passingEntries.length && (
                      <tr>
                        <td colSpan={6} className="district-result-empty">
                          No results scoring 50% or above are available for this competition.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </section>
            );
          })}
          {!submittedDistrictResults.length && (
            <section className="district-result-card">
              <p className="district-result-empty">
                No district results have been submitted to the zone yet.
              </p>
            </section>
          )}
        </div>
      );
    }

    return (
      <div className="district-results-stack">
        <div className="district-results-heading">
          <div><h2>District-level results</h2><p>Promoted students are shown talent by talent. Edit and save each district score here.</p></div>
        </div>

        {districtResultsByCompetition.filter((competition) =>
          !districtSubmissions.some((submission) =>
            Number(submission.competition) === Number(competition.id) &&
            submission.status === 'submitted'
          )
        ).map((competition) => (
          (() => {
            const zonePromotedDetailIds = new Set(
              competition.entries
                .filter((result) => result.detail && (result.isZonePromoted || result.detail.promoted_to === 'zone'))
                .map((result) => Number(result.detail.id)),
            );
            const qualifyingEntries = competition.entries.filter((result) => result.detail && Number(result.detail.percentage_score) >= 50);
            const districtSubmission = districtSubmissions.find((submission) => Number(submission.competition) === Number(competition.id));
            const isSubmittedToZone = Boolean(districtSubmission?.status === 'submitted')
              || competition.entries.some((result) => result.detail && zonePromotedDetailIds.has(Number(result.detail.id)))
              || qualifyingEntries.some((result) => zonePromotedDetailIds.has(Number(result.detail.id)));
            const isLockedForDistrictEdit = (result) => Boolean(
              isSubmittedToZone || (result.detail && (
                ['district', 'zone', 'country'].includes(result.detail.promoted_to) || zonePromotedDetailIds.has(Number(result.detail.id))
              ))
            );

            return (
          <section className="district-result-card" key={`district-${competition.id}`}>
            <div className="district-result-card-header">
              <div><h3>{competition.name}</h3><p>District-level results for promoted students.</p></div>
              <div className="district-result-header-actions">
                {!isSubmittedToZone && <button type="button" className="district-demote-button" onClick={() => handleDemoteTalents(selectedDemotionDetails.filter((detailId) => competition.entries.some((entry) => Number(entry.detail?.id) === Number(detailId))))} disabled={submitting || !selectedDemotionDetails.some((detailId) => competition.entries.some((entry) => Number(entry.detail?.id) === Number(detailId)))}>De-promote selected</button>}
                {!isSubmittedToZone && <button
                  type="button"
                  className="district-submit-zone-button"
                  onClick={() => handleSubmitDistrictResults(competition.id)}
                  disabled={submittingDistrictCompetitionId !== null || !competition.entries.length}
                  title="Submit all qualifying district results to the zone level"
                  style={{ padding: '8px 16px', border: '1px solid #e5e7eb', borderRadius: '6px', background: '#0E1DB6', color: 'white', fontSize: '14px', cursor: 'pointer', transition: 'all 0.2s' }}
                >
                  {submittingDistrictCompetitionId === Number(competition.id) ? 'Submitting...' : 'Submit to zone'}
                </button>}
              </div>
            </div>
            <div className="district-result-table-wrap">
                <table className="data-table"><thead><tr>{!isSubmittedToZone && <th>Select</th>}<th>Student</th><th>Talent</th><th>Class</th><th>School</th><th>Club</th><th>Result Status</th><th>Score</th><th>Grade</th></tr></thead><tbody>
                {competition.entries.map((result) => (
                  <tr key={`${result.id}-${result.detail?.id || 'overall'}`}>{!isSubmittedToZone && <td>{result.detail ? <input type="checkbox" checked={selectedDemotionDetails.includes(Number(result.detail.id))} onChange={(event) => setSelectedDemotionDetails((current) => event.target.checked ? [...new Set([...current, Number(result.detail.id)])] : current.filter((id) => id !== Number(result.detail.id)))} aria-label={`Select ${result.student?.first_name || 'student'} ${result.detail?.talent_name || 'result'} for de-promotion`} disabled={isLockedForDistrictEdit(result)} /> : null}</td>}<td>{result.student ? `${result.student.first_name} ${result.student.last_name}` : 'Student'}</td><td>{result.detail?.talent_name || 'Overall result'}</td><td>{getStudentClassName(result.student)}</td><td>{districtSchools.find((school) => Number(school.id) === Number(result.student?.school?.id ?? result.student?.school))?.name || 'School'}</td><td>{clubMemberships.find((membership) => Number(membership.student) === Number(result.student?.id) && membership.is_active)?.club_name || '—'}</td><td>{!result.detail || result.detail.percentage_score == null ? <span className="district-status-badge is-pending">Pending</span> : <span className={`district-status-badge ${Number(result.detail.percentage_score) < 50 ? 'is-fail' : 'is-pending'}`}>{Number(result.detail.percentage_score) < 50 ? 'Fail' : 'Pending'}</span>}</td><td><input className="district-score-input" type="number" min="0" max="100" defaultValue={result.detail ? (result.detail.percentage_score ?? '') : ''} disabled={isLockedForDistrictEdit(result)} onBlur={(event) => handleSaveDistrictScore(result.id, result.detail?.id, event.target.value)} aria-label={`Score for ${result.student_name || 'student'} ${result.detail?.talent_name || 'result'}`} /></td><td>{result.detail ? (result.detail.percentage_score === null || result.detail.percentage_score === undefined ? 'Not recorded' : result.detail.percentage_score >= 90 ? 'A+' : result.detail.percentage_score >= 75 ? 'A' : result.detail.percentage_score >= 60 ? 'B+' : result.detail.percentage_score >= 50 ? 'B' : result.detail.percentage_score >= 40 ? 'C' : result.detail.percentage_score >= 30 ? 'D' : result.detail.percentage_score >= 20 ? 'E' : 'F') : result.grade || 'Not recorded'}</td></tr>
                ))}
                {!competition.entries.length && <tr><td colSpan={isSubmittedToZone ? 8 : 9} className="district-result-empty">No district results recorded yet.</td></tr>}
              </tbody></table>
            </div>
          </section>
            );
          })()
        ))}

      </div>
    );
  };

  const renderAnnouncementsView = () => (
    <div className="district-announcements-page">
      <section className="district-announcements-card">
        <div className="district-announcements-header">
          <div><h2>Higher-level announcements ({higherLevelAnnouncements.length})</h2><p>Read-only announcements from national, zone, and region leadership.</p></div>
        </div>
        <div className="district-announcements-list">
          {higherLevelAnnouncements.map((announcement) => (
            <article key={announcement.id} className="district-announcement-item">
              <div className="district-announcement-item-heading"><strong className="district-announcement-readonly-title">{announcement.title}</strong><span>Read only · {announcement.scope} · {announcement.published_at || announcement.created_at ? new Date(announcement.published_at || announcement.created_at).toLocaleDateString('en-GB') : 'Date unavailable'}</span></div>
              <p>{announcement.content || 'No details available.'}</p>
            </article>
          ))}
          {!higherLevelAnnouncements.length && <p className="district-empty-state">No higher-level announcements available.</p>}
        </div>
      </section>

      <section className="district-announcements-card">
        <div className="district-announcements-header">
          <div><h2>District announcements ({lowerLevelAnnouncements.length})</h2><p>Announcements published by {districtName} for the district audience.</p></div>
          <button type="button" className="district-primary-button district-card-action" onClick={() => openAnnouncementEditor()}>Add announcement</button>
        </div>
        <div className="district-announcements-list">
          {lowerLevelAnnouncements.map((announcement) => (
            <article key={announcement.id} className="district-announcement-item">
              <div className="district-announcement-item-heading"><button type="button" className="district-announcement-title" onClick={() => openAnnouncementEditor(announcement)}>{announcement.title}</button><span>District · {announcement.published_at || announcement.created_at ? new Date(announcement.published_at || announcement.created_at).toLocaleDateString('en-GB') : 'Date unavailable'}</span></div>
              <p>{announcement.content || 'No details available.'}</p>
            </article>
          ))}
          {!lowerLevelAnnouncements.length && <p className="district-empty-state">No district announcements yet.</p>}
        </div>
      </section>
    </div>
  );

  return (
    <div className="sport-teacher-page district-manager-page">
      <header className="sport-teacher-app-bar">
        <div className="sport-teacher-brand">
          <img src={logo} alt="Talanta logo" />
          <span>Talanta Management System</span>
        </div>
        <div className="sport-teacher-app-actions">
          <ProfileMenu
            isOpen={profileMenuOpen}
            onToggle={() => setProfileMenuOpen((open) => !open)}
            onProfile={openProfileDrawer}
            onChangePassword={openChangePasswordDrawer}
            onLogout={() => { setProfileMenuOpen(false); logout(); }}
            username={currentUser?.username}
          />
          <button type="button" className="sport-teacher-navigation-toggle" onClick={() => setSidebarOpen((open) => !open)} aria-label="Open navigation menu" aria-expanded={sidebarOpen} title="Open navigation menu">
            <span /><span /><span />
          </button>
        </div>
      </header>

      <aside
        className={`sport-teacher-navigation district-manager-navigation nav flex-column gap-1 p-2 ${
          sidebarOpen ? 'is-open' : ''
        }`}
        aria-label="District Manager navigation"
      >
        <div className="sport-teacher-navigation-heading px-2 py-2">
          {districtName}
        </div>

        {navLinks.map((item) => (
          <button
            type="button"
            key={item.key}
            className={`btn text-start w-100 district-manager-nav-link ${
              item.active ? 'active' : ''
            }`}
            aria-current={item.active ? 'page' : undefined}
            onClick={() => {
              item.onClick();
              setSidebarOpen(false);
            }}
          >
            {item.label}
          </button>
        ))}
      </aside>

      <main className="sport-teacher-prototype-content district-manager-content">
        {error && <div className="district-manager-alert">{error}<button type="button" onClick={() => setError(null)} aria-label="Dismiss error">&times;</button></div>}
        {success && <div className="district-manager-alert" style={{ background: '#ecfdf5', color: '#166534', borderColor: '#a7f3d0' }}>{success}<button type="button" onClick={() => setSuccess(null)} aria-label="Dismiss success">&times;</button></div>}
        {loading ? <DashboardSkeleton label="Loading district manager dashboard" /> : (
          <>

      {activeMenu === 'registered-schools' && (
        <section className="district-content-section">
          <div className="district-section-heading">
            <h2>Registered Schools</h2>
            <p>Total schools: {districtSchools.length}</p>
          </div>

          {editingSchoolId !== null && (
            <form
              className="sport-teacher-registration-form"
              onSubmit={handleUpdateRegisteredSchool}
              style={{ marginBottom: '20px' }}
            >
              <div className="district-section-heading">
                <h3>Update School Details</h3>
                <p>Update school information while keeping the school within your assigned district.</p>
              </div>

              <div className="sport-teacher-registration-form-grid">
                <label data-label="School name">
                  <input
                    required
                    value={schoolEditForm.name}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, name: event.target.value }))}
                    placeholder="School name"
                  />
                </label>
                <label data-label="Registration number">
                  <input
                    required
                    value={schoolEditForm.registry_number}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, registry_number: event.target.value }))}
                    placeholder="Registration number"
                  />
                </label>
                <label data-label="Ownership type">
                  <select
                    required
                    value={schoolEditForm.ownership_type}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, ownership_type: event.target.value }))}
                  >
                    <option value="">Select ownership type</option>
                    {schoolOwnershipTypes.map((option) => (
                      <option key={option.id} value={option.name}>{option.name}</option>
                    ))}
                    {!schoolOwnershipTypes.some((option) => option.name === schoolEditForm.ownership_type) && schoolEditForm.ownership_type && (
                      <option value={schoolEditForm.ownership_type}>{schoolEditForm.ownership_type}</option>
                    )}
                  </select>
                </label>
                <label data-label="District">
                  <input value={districtName} disabled readOnly />
                </label>
                <label data-label="Ward">
                  <select
                    required
                    value={schoolEditForm.ward}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, ward: event.target.value }))}
                  >
                    <option value="">Select ward</option>
                    {wards
                      .filter((ward) => Number(ward.district?.id ?? ward.district) === Number(currentUser?.district))
                      .map((ward) => <option key={ward.id} value={ward.id}>{ward.name}</option>)}
                  </select>
                </label>
                <label data-label="Phone">
                  <input
                    type="tel"
                    value={schoolEditForm.phone}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, phone: event.target.value }))}
                    placeholder="School phone"
                  />
                </label>
                <label data-label="Physical address">
                  <input
                    value={schoolEditForm.physical_address}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, physical_address: event.target.value }))}
                    placeholder="Physical address"
                  />
                </label>
                <label data-label="Email">
                  <input
                    type="email"
                    value={schoolEditForm.email}
                    onChange={(event) => setSchoolEditForm((old) => ({ ...old, email: event.target.value }))}
                    placeholder="school@example.com"
                  />
                </label>
              </div>

              <div className="district-competition-form-actions">
                <button
                  type="button"
                  className="sport-teacher-secondary-button"
                  onClick={() => setEditingSchoolId(null)}
                  disabled={schoolManagementSubmitting}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="district-primary-button"
                  disabled={schoolManagementSubmitting}
                >
                  {schoolManagementSubmitting ? 'Saving...' : 'Save Changes'}
                </button>
              </div>
            </form>
          )}

          <div className="table-responsive">
            <table className="table table-striped table-hover align-middle">
              <thead>
                <tr>
                  <th>#</th>
                  <th>School name</th>
                  <th>Registration number</th>
                  <th>Ward</th>
                  <th>Ownership</th>
                  <th>Phone</th>
                  <th>Email</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {districtSchools.map((school, index) => {
                  const wardId = Number(school.ward?.id ?? school.ward);
                  const wardName =
                    school.ward?.name ||
                    wards.find((ward) => Number(ward.id) === wardId)?.name ||
                    '—';

                  return (
                    <tr key={school.id}>
                      <td>{index + 1}</td>
                      <td>{school.name || '—'}</td>
                      <td>{school.registry_number || school.registration_number || '—'}</td>
                      <td>{wardName}</td>
                      <td>{school.ownership_type?.name || school.ownership_type || '—'}</td>
                      <td>{school.phone || '—'}</td>
                      <td>{school.email || '—'}</td>
                      <td>
                        {!school.is_active
                          ? <span className="badge bg-danger">Suspended</span>
                          : school.is_approved
                            ? <span className="badge bg-success">Active</span>
                            : <span className="badge bg-warning text-dark">Pending Approval</span>}
                      </td>
                      <td>
                        <div className="d-flex flex-wrap gap-1">
                          <button
                            type="button"
                            className="btn btn-sm btn-outline-primary"
                            onClick={() => openSchoolEditor(school)}
                            disabled={schoolManagementSubmitting}
                          >
                            Update
                          </button>
                          <button
                            type="button"
                            className={`btn btn-sm ${school.is_active === false ? 'btn-success' : 'btn-warning'}`}
                            onClick={() => handleToggleSchoolActive(school)}
                            disabled={schoolManagementSubmitting}
                          >
                            {school.is_active === false ? 'Activate' : 'Suspend'}
                          </button>
                          <button
                            type="button"
                            className="btn btn-sm btn-outline-danger"
                            onClick={() => handleDeleteRegisteredSchool(school)}
                            disabled={schoolManagementSubmitting}
                          >
                            Delete
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
                {!districtSchools.length && (
                  <tr>
                    <td colSpan="9" className="text-center">
                      No registered schools found in this district.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>
      )}

      {activeMenu === 'register-school' && (
        <section className="district-content-section">
          <div className="district-section-heading">
            <h2>Register School</h2>
            <p>
              Register a school within {districtName}. New registrations require
              Talent Admin approval before the school is approved.
            </p>
          </div>

          <form
            className="sport-teacher-registration-form"
            onSubmit={submitSchoolRegistration}
          >
            <div className="sport-teacher-registration-form-grid">
              <label data-label="School name">
                <input
                  required
                  placeholder="Enter school name"
                  value={schoolRegistrationForm.name}
                  onChange={(event) =>
                    updateSchoolRegistrationField('name', event.target.value)
                  }
                />
              </label>

              <label data-label="Registration number">
                <input
                  placeholder="Enter registration number"
                  value={schoolRegistrationForm.registry_number}
                  onChange={(event) =>
                    updateSchoolRegistrationField('registry_number', event.target.value)
                  }
                />
              </label>

              <label data-label="Ownership type">
                <select
                  required
                  value={schoolRegistrationForm.ownership_type}
                  onChange={(event) =>
                    updateSchoolRegistrationField('ownership_type', event.target.value)
                  }
                >
                  <option value="">Select ownership type</option>
                  {schoolOwnershipTypes.map((option) => (
                    <option key={option.id} value={option.name}>
                      {option.name}
                    </option>
                  ))}
                </select>
              </label>

              <label data-label="District">
                <input value={districtName} disabled readOnly />
              </label>

              <label data-label="Ward">
                <select
                  required
                  value={schoolRegistrationForm.ward}
                  onChange={(event) =>
                    updateSchoolRegistrationField('ward', event.target.value)
                  }
                >
                  <option value="">Select ward</option>
                  {wards
                    .filter(
                      (ward) =>
                        Number(ward.district?.id ?? ward.district)
                        === Number(currentUser?.district)
                    )
                    .map((ward) => (
                      <option key={ward.id} value={ward.id}>
                        {ward.name}
                      </option>
                    ))}
                </select>
              </label>

              <label data-label="Phone">
                <input
                  type="tel"
                  placeholder="School phone number"
                  value={schoolRegistrationForm.phone}
                  onChange={(event) =>
                    updateSchoolRegistrationField('phone', event.target.value)
                  }
                />
              </label>

              <label data-label="Physical address">
                <input
                  placeholder="School physical address"
                  value={schoolRegistrationForm.physical_address}
                  onChange={(event) =>
                    updateSchoolRegistrationField('physical_address', event.target.value)
                  }
                />
              </label>

              <label data-label="Email">
                <input
                  type="email"
                  placeholder="school@example.com"
                  value={schoolRegistrationForm.email}
                  onChange={(event) =>
                    updateSchoolRegistrationField('email', event.target.value)
                  }
                />
              </label>
            </div>

            <div className="sport-teacher-registration-form-grid">
              <button
                type="button"
                className="sport-teacher-secondary-button"
                onClick={() => setActiveMenu('home')}
                disabled={schoolRegistrationSubmitting}
              >
                Cancel
              </button>

              <button
                type="submit"
                className="district-primary-button"
                disabled={schoolRegistrationSubmitting}
              >
                {schoolRegistrationSubmitting
                  ? 'Submitting...'
                  : 'Register'}
              </button>
            </div>
          </form>
        </section>
      )}

      {activeMenu === 'home' && renderHomeView()}
            {(activeMenu === 'school-results' || activeMenu === 'promoted-school-results' || activeMenu === 'district-results' || activeMenu === 'district-archive-results') && renderResultsView()}
            {activeMenu === 'announcements' && renderAnnouncementsView()}
          </>
        )}
      </main>
      {competitionDrawerOpen && (
        <>
          <button type="button" className="sport-teacher-drawer-backdrop" aria-label="Close competition form" onClick={closeCompetitionEditor} />
          <aside className="sport-teacher-search-drawer sport-teacher-registration-drawer district-competition-drawer" style={{ '--drawer-width': `${competitionDrawerWidth}px` }} aria-label="District competition form">
            <div className="sport-teacher-drawer-resize-edge" onPointerDown={(event) => { event.preventDefault(); setIsResizingCompetitionDrawer(true); }} role="separator" aria-label="Resize competition panel" />
            <div className="sport-teacher-search-drawer-header"><h2>{selectedCompetition ? 'Edit competition' : 'Add competition'}</h2><button type="button" onClick={closeCompetitionEditor} aria-label="Close competition form">&times;</button></div>
            <form onSubmit={handleSaveCompetition} className="sport-teacher-profile-form">
              <p className="district-drawer-note">This event will be visible to schools in {districtName}.</p>
              <label>Competition name *<input type="text" value={competitionForm.name} placeholder="e.g. District Athletics Cup" onChange={(event) => setCompetitionForm({ ...competitionForm, name: event.target.value })} maxLength="150" required /></label>
              <label>Competition Talent *
                <select
                  value={competitionForm.talent}
                  onChange={(event) => setCompetitionForm({ ...competitionForm, talent: event.target.value })}
                  required
                >
                  <option value="">Select one talent</option>
                  {[...new Map(districtTalents.map((entry) => {
                    const talentId = Number(entry.talent?.id ?? entry.talent);
                    return [talentId, {
                      id: talentId,
                      name: entry.talent_name || entry.talent?.name || 'Talent',
                    }];
                  }).filter(([id]) => Number.isFinite(id) && id > 0)).values()]
                    .sort((a, b) => a.name.localeCompare(b.name))
                    .map((talent) => (
                      <option key={talent.id} value={talent.id}>{talent.name}</option>
                    ))}
                </select>
              </label>
              <label>Competition Description<textarea value={competitionForm.description} placeholder="Optional competition summary..." onChange={(event) => setCompetitionForm({ ...competitionForm, description: event.target.value })} rows="5" /></label>
              <label>Competition Venue<input type="text" value={competitionForm.venue} placeholder="Enter the competition venue" onChange={(event) => setCompetitionForm({ ...competitionForm, venue: event.target.value })} maxLength="255" /></label>
              <div className="district-competition-date-grid"><label>Start date *<input type="date" value={competitionForm.start_date} onChange={(event) => setCompetitionForm({ ...competitionForm, start_date: event.target.value })} required /></label><label>End date<input type="date" value={competitionForm.end_date} onChange={(event) => setCompetitionForm({ ...competitionForm, end_date: event.target.value })} min={competitionForm.start_date || undefined} /></label></div>
              <div className="district-competition-form-actions">{selectedCompetition && <button type="button" className="district-competition-delete" onClick={handleDeleteCompetition} disabled={competitionSubmitting}>Delete</button>}<button type="submit" className="district-primary-button" disabled={competitionSubmitting}>{competitionSubmitting ? 'Saving...' : selectedCompetition ? 'Save changes' : 'Create competition'}</button></div>
            </form>
          </aside>
        </>
      )}
      {announcementDrawerOpen && (
        <>
          <button type="button" className="sport-teacher-drawer-backdrop sport-teacher-registration-backdrop" aria-label="Close announcement form" onClick={() => setAnnouncementDrawerOpen(false)} />
          <aside className="sport-teacher-search-drawer sport-teacher-registration-drawer district-competition-drawer" style={{ '--drawer-width': `${competitionDrawerWidth}px` }} aria-label="District announcement form">
            <div className="sport-teacher-drawer-resize-edge" onPointerDown={(event) => { event.preventDefault(); setIsResizingCompetitionDrawer(true); }} role="separator" aria-label="Resize announcement panel" />
            <div className="sport-teacher-search-drawer-header"><h2>{selectedAnnouncement ? 'Edit announcement' : 'New announcement'}</h2><button type="button" onClick={() => setAnnouncementDrawerOpen(false)} aria-label="Close announcement form">&times;</button></div>
            <form onSubmit={handleCreateAnnouncement}>
              <div className="sport-teacher-announcement-form district-announcement-drawer-form">
                <label>Title *<input type="text" value={announcementForm.title} placeholder="e.g. School sports meeting" onChange={(event) => setAnnouncementForm({ ...announcementForm, title: event.target.value })} maxLength="200" required /></label>
                <label>Message *<textarea value={announcementForm.content} placeholder="Type the announcement details here..." onChange={(event) => setAnnouncementForm({ ...announcementForm, content: event.target.value })} rows="7" required /></label>
                <label>
                  Send announcement to *
                  <select
                    value={announcementForm.audience}
                    onChange={(event) => setAnnouncementForm({
                      ...announcementForm,
                      audience: event.target.value,
                    })}
                    required
                  >
                    <option value="students">Students only</option>
                    <option value="sport_teachers">Sports Teachers only</option>
                    <option value="both">Students and Sports Teachers</option>
                  </select>
                </label>
                <div className="sport-teacher-announcement-form-actions">
                  <div className="announcement-date-fields">
                  <div className="announcement-date-field"><label>Starting date and time *<input type="datetime-local" value={announcementForm.published_at || ""} onChange={(event) => setAnnouncementForm({ ...announcementForm, published_at: event.target.value })} required /></label></div>
                  <div className="announcement-date-field"><label>Expire date and time *<input type="datetime-local" value={announcementForm.expires_at || ""} min={announcementForm.published_at || undefined} onChange={(event) => setAnnouncementForm({ ...announcementForm, expires_at: event.target.value })} required /></label></div>
                  </div>
                  {selectedAnnouncement && <button type="button" className="sport-teacher-announcement-delete" onClick={handleDeleteDistrictAnnouncement} disabled={announcementSubmitting}>Delete</button>}
                  <button type="submit" disabled={announcementSubmitting}>{announcementSubmitting ? 'Publishing...' : selectedAnnouncement ? 'Save changes' : 'Publish'}</button>
                </div>
              </div>
            </form>
          </aside>
        </>
      )}
      {profileDrawerOpen && (
        <>
          <button type="button" className="sport-teacher-drawer-backdrop sport-teacher-registration-backdrop" aria-label="Close profile" onClick={() => setProfileDrawerOpen(false)} />
          <aside className="sport-teacher-search-drawer sport-teacher-registration-drawer district-competition-drawer" style={{ '--drawer-width': `${competitionDrawerWidth}px` }} aria-label="Profile details">
            <div className="sport-teacher-drawer-resize-edge" onPointerDown={(event) => { event.preventDefault(); setIsResizingCompetitionDrawer(true); }} role="separator" aria-label="Resize profile panel" />
            <div className="sport-teacher-search-drawer-header"><h2>Profile</h2><button type="button" onClick={() => setProfileDrawerOpen(false)} aria-label="Close profile">&times;</button></div>
            <form onSubmit={handleSaveProfile} className="sport-teacher-profile-form"><div className="sport-teacher-profile-details"><div><span>Username:</span><strong>{currentUser?.username || '-'}</strong></div><div><span>Firstname:</span><strong>{currentUser?.first_name || '-'}</strong></div><div><span>Lastname:</span><strong>{currentUser?.last_name || '-'}</strong></div><div><span>Role:</span><strong>{currentUser?.role || '-'}</strong></div><div><span>District:</span><strong>{districtName}</strong></div></div><label>Email<input type="email" value={profileEmail} onChange={(event) => setProfileEmail(event.target.value)} /></label><label>Phone number<input type="tel" value={profilePhone} onChange={(event) => setProfilePhone(event.target.value)} pattern="(?:0\d{9}|\+255\d{9})" placeholder="0712345678 or +255712345678" title="Use 10 digits starting with 0 or 13 characters starting with +255" /></label>{profileMessage && <div className={`district-profile-message is-${profileMessage.type}`} role="status">{profileMessage.text}</div>}<button type="submit" className="sport-teacher-profile-submit" disabled={profileSubmitting}>{profileSubmitting ? 'Saving...' : 'Save profile'}</button></form>
          </aside>
        </>
      )}
      {passwordDrawerOpen && (
        <>
          <button type="button" className="sport-teacher-drawer-backdrop sport-teacher-registration-backdrop" aria-label="Close change password" onClick={() => setPasswordDrawerOpen(false)} />
          <aside className="sport-teacher-search-drawer sport-teacher-registration-drawer district-competition-drawer" style={{ '--drawer-width': `${competitionDrawerWidth}px` }} aria-label="Change password">
            <div className="sport-teacher-drawer-resize-edge" onPointerDown={(event) => { event.preventDefault(); setIsResizingCompetitionDrawer(true); }} role="separator" aria-label="Resize password panel" />
            <div className="sport-teacher-search-drawer-header"><h2>Change password</h2><button type="button" onClick={() => setPasswordDrawerOpen(false)} aria-label="Close change password">&times;</button></div>
            <form onSubmit={handleChangePassword} className="sport-teacher-profile-form"><label>New password<span className="sport-teacher-password-control"><input type={showProfilePassword ? 'text' : 'password'} value={profilePasswordForm.new_password} onChange={(event) => setProfilePasswordForm({ ...profilePasswordForm, new_password: event.target.value })} minLength="8" required /><button type="button" onClick={() => setShowProfilePassword((visible) => !visible)} aria-label={showProfilePassword ? 'Hide new password' : 'Show new password'}><EyeIcon visible={showProfilePassword} /></button></span></label><label>Confirm password<span className="sport-teacher-password-control"><input type={showProfilePasswordConfirmation ? 'text' : 'password'} value={profilePasswordForm.confirm_password} onChange={(event) => setProfilePasswordForm({ ...profilePasswordForm, confirm_password: event.target.value })} minLength="8" required /><button type="button" onClick={() => setShowProfilePasswordConfirmation((visible) => !visible)} aria-label={showProfilePasswordConfirmation ? 'Hide password confirmation' : 'Show password confirmation'}><EyeIcon visible={showProfilePasswordConfirmation} /></button></span></label><button type="submit" className="sport-teacher-profile-submit" disabled={profileSubmitting}>{profileSubmitting ? 'Saving...' : 'Save password'}</button></form>
          </aside>
        </>
      )}
    </div>
  );
}

