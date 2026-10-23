import { Link } from 'react-router-dom';
import './AboutDeveloperPage.css';

export default function AboutDeveloperPage() {
  return (
    <main className="developer-page">
      <div className="developer-container">
        <Link to="/login" className="developer-back">
          <span aria-hidden="true">←</span> Back to Login
        </Link>

        <section className="developer-card">
          <header className="developer-hero">
            <img
              src="/developer.jpg"
              alt="Eng Isack Seba"
              className="developer-avatar"
            />

            <p className="developer-eyebrow">About the Developer</p>

            <h1 className="developer-name">Eng Isack Seba</h1>

            <p className="developer-role">
              Software Engineer &amp; System Developer
            </p>

            <span className="developer-badge">
              <span aria-hidden="true">✦</span>
              Creator of Talantaz
            </span>
          </header>

          <div className="developer-content">
            <section className="developer-section">
              <h2 className="developer-section-title">My Profile</h2>

              <p className="developer-description">
                I am a software developer passionate about building useful
                technology solutions. I developed Talantaz to support talent
                identification, assessment and management, helping schools
                organise student talent information and competition results.
              </p>

              <p className="developer-description">
                My goal is to build reliable, accessible and practical digital
                systems that help people and organisations work more effectively.
              </p>
            </section>

            <section className="developer-section">
              <h2 className="developer-section-title">Programming Languages</h2>
              <div className="developer-skills">
                {['Python', 'JavaScript', 'PHP', 'C++', 'SQL', 'HTML', 'CSS'].map((skill) => (
                  <span className="developer-skill" key={skill}>{skill}</span>
                ))}
              </div>
            </section>

            <section className="developer-section">
              <h2 className="developer-section-title">Frameworks & Technologies</h2>
              <div className="developer-skills">
                {['Django', 'React', 'Laravel', 'MySQL', 'Bootstrap', 'Git & GitHub'].map((skill) => (
                  <span className="developer-skill" key={skill}>{skill}</span>
                ))}
              </div>
            </section>

            <section className="developer-section">
              <h2 className="developer-section-title">Contact Me</h2>

              <div className="developer-contact-list">
                <a
                  href="https://wa.me/255752122502"
                  target="_blank"
                  rel="noreferrer"
                  className="developer-contact"
                >
                  <span className="developer-contact-icon" aria-hidden="true">
                    ◉
                  </span>
                  <span>
                    <span className="developer-contact-label">WhatsApp</span>
                    <span className="developer-contact-value">0752122502</span>
                  </span>
                </a>

                <a
                  href="tel:+255795122502"
                  className="developer-contact"
                >
                  <span className="developer-contact-icon" aria-hidden="true">
                    ☎
                  </span>
                  <span>
                    <span className="developer-contact-label">Normal Call</span>
                    <span className="developer-contact-value">0795122502</span>
                  </span>
                </a>

                <a
                  href="mailto:sebastianisack8@gmail.com"
                  className="developer-contact"
                >
                  <span className="developer-contact-icon" aria-hidden="true">
                    ✉
                  </span>
                  <span>
                    <span className="developer-contact-label">Email</span>
                    <span className="developer-contact-value">
                      sebastianisack8@gmail.com
                    </span>
                  </span>
                </a>
              </div>
            </section>
          </div>

          <footer className="developer-footer">
            © 2026 Design and Developed by{' '}
            <strong>Eng Isack Seba</strong>. All rights reserved.
          </footer>
        </section>
      </div>
    </main>
  );
}
